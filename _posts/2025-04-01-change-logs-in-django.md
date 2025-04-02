---
layout: post
title: Implementing Change Logs in a Django App
categories: [Software Development]
image: /assets/img/django-change-logs.jpg
tags: [Python, Django, ChangeLogs]
description: Change logs (or audit logs) are crucial for tracking modifications to your data over time. They provide transparency, accountability, and can be invaluable for debugging or compliance purposes. In this comprehensive guide, I'll walk through several approaches to implementing change logs in Django, complete with practical examples.
render_with_liquid: false
featured: true
canonical_url: https://blogs.innova.co.ke/change-logs-in-django/
---

# Implementing Change Logs in a Django App

Change logs (or audit logs) are crucial for tracking modifications to your data over time. They provide transparency, accountability, and can be invaluable for debugging or compliance purposes. In this comprehensive guide, I'll walk through several approaches to implementing change logs in Django, complete with practical examples.

## Why Implement Change Logs?

Before diving into implementation, let's consider why you might need change logs:

1. **Audit compliance**: Many industries require tracking of data changes
2. **Debugging**: Understand when and how data changed
3. **Accountability**: Know who made specific changes
4. **Data recovery**: Revert to previous states if needed
5. **Analytics**: Understand patterns in data modification

## Approach 1: Using Django's Built-in Signals

Django's signal system provides a straightforward way to implement basic change logging.

### Implementation Example

```python
# models.py
from django.db import models
from django.db.models.signals import post_save, post_delete, pre_save
from django.dispatch import receiver
from django.contrib.auth import get_user_model

User = get_user_model()

class Product(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    updated_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, editable=False)

    _change_tracker = {} # Stores original field values

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._store_original_values()

    def _store_original_values(self):
        """Store original field values when instance is loaded"""
        self._change_tracker = {
            field.name: getattr(self, field.name)
            for field in self._meta.fields
            if field.name not in ['id', 'created_at', 'updated_at']
        }

    def get_changes(self):
        """Return dictionary of changed fields and their old/new values"""
        changes = {}
        for field in self._meta.fields:
            field_name = field.name
            if field_name in ['id', 'created_at', 'updated_at', 'updated_by']:
                continue
            
            old_value = self._change_tracker.get(field_name)
            new_value = getattr(self, field_name)
            
            if old_value != new_value:
                changes[field_name] = {
                    'old': str(old_value),
                    'new': str(new_value),
                    'field_type': field.get_internal_type()
                }
        return changes

    def save(self, *args, **kwargs):
        """Override save to track changes and set updated_by"""
        if not self.pk:
            # New instance - no changes to track
            changes = None
        else:
            changes = self.get_changes()
            if not changes:
                # No actual changes - skip logging
                return super().save(*args, **kwargs)
        
        # Set updated_by if available
        from django.contrib.auth import get_user
        try:
            user = get_user(None)
            if user and user.is_authenticated:
                self.updated_by = user
        except:
            pass
        
        result = super().save(*args, **kwargs)
        
        # Create change log after saving
        if self.pk and changes:
            ChangeLog.objects.create(
                model_name=self.__class__.__name__,
                object_id=self.pk,
                action=ChangeLog.ACTION_UPDATE,
                changes=changes,
                user=self.updated_by,
            )
        return result

    def __str__(self):
        return self.name

class ChangeLog(models.Model):
    ACTION_CREATE = 'create'
    ACTION_UPDATE = 'update'
    ACTION_DELETE = 'delete'
    
    ACTION_CHOICES = [
        (ACTION_CREATE, 'Create'),
        (ACTION_UPDATE, 'Update'),
        (ACTION_DELETE, 'Delete'),
    ]
    
    model_name = models.CharField(max_length=100)
    object_id = models.CharField(max_length=100)
    action = models.CharField(max_length=10, choices=ACTION_CHOICES)
    changes = models.JSONField(null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    change_reason = models.CharField(max_length=255, null=True, blank=True)

    class Meta:
        ordering = ['-timestamp']
        indexes = [
            models.Index(fields=['model_name', 'object_id']),
        ]
    
    def __str__(self):
        return f"{self.get_action_display()} on {self.model_name} #{self.object_id}"


@receiver(pre_save, sender=Product)
def capture_product_changes(sender, instance, **kwargs):
    """Store original values before save"""
    if instance.pk:  # Only for existing instances
        instance._original_values = {
            field.name: getattr(instance, field.name)
            for field in instance._meta.fields
            if field.name not in ['id', 'created_at', 'updated_at']
        }

@receiver(post_save, sender=Product)
def log_product_change(sender, instance, created, **kwargs):
    action = ChangeLog.ACTION_CREATE if created else ChangeLog.ACTION_UPDATE
    
    changes = None
    if not created and hasattr(instance, '_original_values'):
        changes = {}
        for field in instance._meta.fields:
            field_name = field.name
            if field_name in ['id', 'created_at', 'updated_at', 'updated_by']:
                continue
            
            original_value = instance._original_values.get(field_name)
            current_value = getattr(instance, field_name)
            
            if original_value != current_value:
                changes[field_name] = {
                    'old': str(original_value),
                    'new': str(current_value),
                    'field': field.verbose_name or field_name
                }
        
        if not changes:
            print("No actual changes detected")
            return
    
    ChangeLog.objects.create(
        model_name=instance.__class__.__name__,
        object_id=instance.pk,
        action=action,
        changes=changes,
        user=instance.updated_by,
    )
    print(f"Logged {action} for product {instance.pk}")

@receiver(post_delete, sender=Product)
def log_product_deletion(sender, instance, **kwargs):
    ChangeLog.objects.create(
        model_name=instance.__class__.__name__,
        object_id=instance.pk,
        action=ChangeLog.ACTION_DELETE,
        user=instance.updated_by,
    )
```

### Pros and Cons

**Pros:**
- Simple to implement
- No additional dependencies
- Works for all models with minimal setup

**Cons:**
- Limited functionality
- Doesn't track changes in related objects
- Can't easily revert changes

Find the complete demo <a href="https://github.com/cartel360/Django-Changelogs-Demo/tree/signal-based-logging" target="_blank"> here </a> 

## Approach 2: Using django-simple-history

For more robust change logging, the `django-simple-history` package is a popular choice.

### Installation

```bash
pip install django-simple-history
```

### Implementation Example

```python
# models.py
from django.db import models
from django.contrib.auth.models import User
from simple_history.models import HistoricalRecords

class Product(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    updated_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    
    history = HistoricalRecords(
        excluded_fields=['created_at', 'updated_at'],
        history_change_reason_field=models.TextField(null=True),
        user_model=User,
    )

    @property
    def _history_user(self):
        return self.updated_by

    @_history_user.setter
    def _history_user(self, value):
        self.updated_by = value

    def __str__(self):
        return self.name
```

### Admin Integration

```python
# admin.py
from django.contrib import admin
from simple_history.admin import SimpleHistoryAdmin
from .models import Product

@admin.register(Product)
class ProductAdmin(SimpleHistoryAdmin):
    list_display = ['name', 'price', 'quantity', 'updated_by']
    history_list_display = ['price', 'quantity']
    search_fields = ['name']
```

### Querying History

```python
# Get all historical records for a product
product = Product.objects.first()
history = product.history.all()

# Get the previous version
previous_version = product.history.first().prev_record

# Revert to a previous version
old_record = product.history.last()
old_record.instance.save()
```

### Pros and Cons

**Pros:**
- Comprehensive solution
- Built-in admin integration
- Tracks all fields automatically
- Allows reverting to previous versions
- Tracks user who made changes

**Cons:**
- Adds extra tables to your database
- Slightly more complex setup
- May impact performance with high-volume changes

Find the complete demo <a href="https://github.com/cartel360/Django-Changelogs-Demo/tree/simple-history" target="_blank"> here </a> 

## Approach 3: Custom Solution with Diff Tracking

For maximum control, you can implement a custom solution that tracks detailed diffs.

### Implementation Example

```python
# models.py
from django.db import models
from django.contrib.auth.models import User
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey
import json
from django.contrib.contenttypes.models import ContentType

class ChangeLog(models.Model):
    ACTION_CREATE = 'create'
    ACTION_UPDATE = 'update'
    ACTION_DELETE = 'delete'
    ACTION_M2M_ADD = 'm2m_add'
    ACTION_M2M_REMOVE = 'm2m_remove'
    ACTION_M2M_CLEAR = 'm2m_clear'
    
    ACTION_CHOICES = [
        (ACTION_CREATE, 'Create'),
        (ACTION_UPDATE, 'Update'),
        (ACTION_DELETE, 'Delete'),
        (ACTION_M2M_ADD, 'M2M Add'),
        (ACTION_M2M_REMOVE, 'M2M Remove'),
        (ACTION_M2M_CLEAR, 'M2M Clear'),
    ]
    
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.CharField(max_length=100)
    content_object = GenericForeignKey('content_type', 'object_id')
    action = models.CharField(max_length=10, choices=ACTION_CHOICES)
    changes = models.JSONField(null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='changes')
    change_reason = models.CharField(max_length=255, null=True, blank=True)
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.CharField(max_length=255, null=True, blank=True)

    class Meta:
        ordering = ['-timestamp']
        indexes = [
            models.Index(fields=['content_type', 'object_id']),
        ]
    
    def __str__(self):
        return f"{self.get_action_display()} on {self.content_type} #{self.object_id}"

class TrackedModel(models.Model):
    """Abstract model for change tracking"""
    class Meta:
        abstract = True
    
    def save(self, *args, **kwargs):
        """Track changes on save"""

        change_reason = kwargs.pop('change_reason', None)
        request = kwargs.pop('request', None)
        
        user = None
        ip_address = None
        user_agent = None
        
        if request and hasattr(request, 'user'):
            user = request.user if request.user.is_authenticated else None
            ip_address = request.META.get('REMOTE_ADDR')
            user_agent = request.META.get('HTTP_USER_AGENT')[:255] if request.META.get('HTTP_USER_AGENT') else None
        
        if self.pk:
            # Existing instance - track updates
            old_instance = self.__class__.objects.get(pk=self.pk)
            changes = self._get_field_changes(old_instance)
            
            if changes:  # Only log if there are actual changes
                ChangeLog.objects.create(
                    content_type=ContentType.objects.get_for_model(self.__class__),
                    object_id=self.pk,
                    action=ChangeLog.ACTION_UPDATE,
                    changes=changes,
                    user=user,
                    change_reason=change_reason,
                    ip_address=ip_address,
                    user_agent=user_agent
                )
        else:
            # New instance - first save to get a PK
            super().save(*args, **kwargs)

            ChangeLog.objects.create(
                content_type=ContentType.objects.get_for_model(self.__class__),
                object_id=self.pk,  # Will be None until saved
                action=ChangeLog.ACTION_CREATE,
                user=user,
                change_reason=change_reason,
                ip_address=ip_address,
                user_agent=user_agent
            )
            return  # Skip the second save
        
        super().save(*args, **kwargs)
        
        # Update the creation log with the new PK if needed
        if not self.pk:
            ChangeLog.objects.filter(
                content_type=ContentType.objects.get_for_model(self.__class__),
                object_id=None,
                action=ChangeLog.ACTION_CREATE
            ).update(object_id=self.pk)
    
    def delete(self, *args, **kwargs):
        """Track deletions"""
        from django.contrib.contenttypes.models import ContentType
        
        change_reason = kwargs.pop('change_reason', None)
        request = kwargs.pop('request', None)
        
        user = None
        ip_address = None
        user_agent = None
        
        if request and hasattr(request, 'user'):
            user = request.user if request.user.is_authenticated else None
            ip_address = request.META.get('REMOTE_ADDR')
            user_agent = request.META.get('HTTP_USER_AGENT')[:255] if request.META.get('HTTP_USER_AGENT') else None
        
        ChangeLog.objects.create(
            content_type=ContentType.objects.get_for_model(self.__class__),
            object_id=self.pk,
            action=ChangeLog.ACTION_DELETE,
            user=user,
            change_reason=change_reason,
            ip_address=ip_address,
            user_agent=user_agent
        )
        
        super().delete(*args, **kwargs)
    
    def _get_field_changes(self, old_instance):
        """Compare fields and return changes"""
        changes = {}
        
        for field in self._meta.fields:
            field_name = field.name
            
            # Skip fields that shouldn't be tracked
            if field_name in ['id', 'created_at', 'updated_at']:
                continue
                
            old_value = getattr(old_instance, field_name)
            new_value = getattr(self, field_name)
            
            if old_value != new_value:
                changes[field_name] = {
                    'old': str(old_value),
                    'new': str(new_value)
                }
        
        return changes or None

class Product(TrackedModel):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    updated_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)

    def __str__(self):
        return self.name
```

### Viewing Changes

```python
# views.py
from django.views.generic import DetailView
from .models import Product, ChangeLog

class ProductChangeLogView(DetailView):
    model = Product
    template_name = 'products/product_changelog_custom.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        content_type = ContentType.objects.get_for_model(Product)
        context['changes'] = ChangeLog.objects.filter(
            content_type=content_type,
            object_id=self.object.pk
        ).select_related('user').order_by('-timestamp')
        return context
```

### Template Example

```html
<!-- templates/products/product_changelog_custom.html -->
<h2>Change History for {{ product.name }}</h2>

<table class="table table-striped">
    <thead>
        <tr>
            <th>Timestamp</th>
            <th>Action</th>
            <th>User</th>
            <th>IP Address</th>
            <th>Changes</th>
            <th>Reason</th>
        </tr>
    </thead>
    <tbody>
        {% for change in changes %}
        <tr>
            <td>{{ change.timestamp|date:"Y-m-d H:i" }}</td>
            <td>{{ change.get_action_display }}</td>
            <td>{{ change.user|default:"System" }}</td>
            <td>{{ change.ip_address|default:"" }}</td>
            <td>
                {% if change.changes %}
                <ul class="mb-0">
                    {% for field, diff in change.changes.items %}
                    <li>
                        <strong>{{ field }}:</strong>
                        {{ diff.old }} → {{ diff.new }}
                    </li>
                    {% endfor %}
                </ul>
                {% endif %}
            </td>
            <td>{{ change.change_reason|default:"" }}</td>
        </tr>
        {% empty %}
        <tr>
            <td colspan="6">No changes recorded</td>
        </tr>
        {% endfor %}
    </tbody>
</table>
```

### Pros and Cons

**Pros:**
- Complete control over implementation
- Can customize exactly what's tracked
- Flexible storage format
- Can add business-specific logic

**Cons:**
- More code to maintain
- Need to handle edge cases
- Requires more testing

Find the complete demo <a href="https://github.com/cartel360/Django-Changelogs-Demo/tree/custom-solution" target="_blank"> here </a> 

## Advanced Considerations

### Performance Optimization

1. **Asynchronous logging**: Use Celery or Django Channels to log changes asynchronously
   ```python
   from celery import shared_task

   @shared_task
   def log_change_async(model_name, object_id, action, changes, user_id):
       user = User.objects.get(pk=user_id) if user_id else None
       ChangeLog.objects.create(
           model_name=model_name,
           object_id=object_id,
           action=action,
           changes=changes,
           user=user
       )

   # In your signal/save method:
   log_change_async.delay(
       model_name=instance.__class__.__name__,
       object_id=instance.pk,
       action=action,
       changes=changes,
       user_id=instance.updated_by.id if instance.updated_by else None
   )
   ```

2. **Batch updates**: For bulk operations, consider separate logging
   ```python
   from django.db.models.signals import m2m_changed

   @receiver(m2m_changed)
   def log_m2m_changes(sender, instance, action, model, pk_set, **kwargs):
       if action.startswith('post_'):
           ChangeLog.objects.create(
               model_name=instance.__class__.__name__,
               object_id=instance.pk,
               action=f'm2m_{action[5:]}',
               changes={
                   'related_model': model.__name__,
                   'related_ids': list(pk_set)
               }
           )
   ```

### Security Considerations

1. **Sensitive data**: Exclude sensitive fields from logging
   ```python
   class User(models.Model):
       # ...
       history = HistoricalRecords(
           excluded_fields=['password', 'last_login', 'security_question']
       )
   ```

2. **Data retention**: Implement automatic pruning of old logs
   ```python
   from django.core.management.base import BaseCommand
   from django.utils import timezone
   from datetime import timedelta

   class Command(BaseCommand):
       help = 'Deletes change logs older than 6 months'

       def handle(self, *args, **options):
           cutoff = timezone.now() - timedelta(days=180)
           deleted = ChangeLog.objects.filter(timestamp__lt=cutoff).delete()
           self.stdout.write(f"Deleted {deleted[0]} old change logs")
   ```

### Full-Text Search

For better searchability of changes:
```python
from django.contrib.postgres.search import SearchVector
from django.contrib.postgres.indexes import GinIndex

class ChangeLog(models.Model):
    # ... existing fields ...
    
    search_vector = SearchVectorField(null=True)
    
    class Meta:
        indexes = [
            GinIndex(fields=['search_vector']),
            # ... other indexes ...
        ]

# In your save method or signal:
from django.contrib.postgres.search import SearchVector

def update_search_vector(sender, instance, **kwargs):
    from django.db.models import Value
    from django.db.models.functions import Concat
    
    instance.search_vector = SearchVector(
        Concat('action', Value(' ')),
        Concat('change_reason', Value(' ')),
        Value(str(instance.changes))
    )
    instance.save(update_fields=['search_vector'])

post_save.connect(update_search_vector, sender=ChangeLog)
```

## Choosing the Right Approach

The best approach depends on your specific needs:

1. **Simple needs**: Django signals (Approach 1)
2. **Comprehensive tracking**: django-simple-history (Approach 2)
3. **Custom requirements**: Custom solution (Approach 3)

Consider these factors when deciding:
- Performance requirements
- Compliance needs
- Complexity of your data model
- Need for reverting changes
- Available development time

## Conclusion

Implementing change logs in Django can range from simple to complex depending on your requirements. For most projects, `django-simple-history` provides the best balance of features and ease of implementation. However, for specialized needs or maximum control, a custom solution might be preferable.

Remember to:
1. Consider performance implications
2. Protect sensitive data
3. Provide meaningful change reasons
4. Implement proper indexing for query performance
5. Consider data retention policies

With proper change logging in place, you'll have greater visibility into your application's data changes and be better prepared for debugging, compliance, and data recovery scenarios.

The link to the repo used for the demo projects is <a href="https://github.com/cartel360/Django-Changelogs-Demo"> here </a>. There are different  branches for the different implementations. Start with the base-setup repo to set up the requirements.
