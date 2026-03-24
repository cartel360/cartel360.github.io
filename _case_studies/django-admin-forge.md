---
title: Django Admin Forge — Because the default admin deserved better
short_title: Django Admin Forge
order: 3
description: Case study — Django Admin Forge, a modern customizable UI layer on Django’s admin.
card_excerpt: Drop-in AdminSite replacement — better navigation, theming, dashboards, and usability without relearning Django.
card_icon: fas fa-screwdriver-wrench
---

<div class="work-page" markdown="1">

<p class="work-meta" markdown="0">
  <span class="work-meta__label">PyPI</span>
  <a href="https://pypi.org/project/django-admin-forge/" target="_blank" rel="noopener noreferrer">django-admin-forge</a>
</p>

### Overview

Built a modern, customizable UI layer on top of Django’s admin—keeping everything developers love (models, permissions, `ModelAdmin`) while replacing the part everyone tolerates: the interface.

Django Admin Forge upgrades the admin experience with better navigation, theming, dashboards, and usability—without forcing developers to relearn how Django works (because no one asked for that).

* * *

### The problem

Django’s admin is powerful, but… let’s be honest:

- The UI feels outdated for modern applications  
- Customization is possible, but painful and inconsistent  
- Navigation breaks down as projects scale  
- There’s no real dashboard or high-level visibility  
- Most teams either live with it—or spend too much time reinventing it  

So you end with a production-grade backend wrapped in a 2008 UI.

* * *

### My role

Sole engineer responsible for:

- Designing and building the package architecture  
- Extending Django’s `AdminSite` without breaking core patterns  
- Creating a theming and configuration system  
- Improving UX across changelists, forms, and navigation  
- Packaging, documentation, and distribution (PyPI)  

Also responsible for making sure this didn’t turn into a polished UI with everything else broken.

* * *

### Key design decisions

#### Django-first, not Django-replacement

- Built as a drop-in `AdminSite` replacement (`forge_admin_site`)  
- Fully compatible with existing models, permissions, and `ModelAdmin`  

Developers keep their workflow—just with less suffering.

#### Configuration over customization

- Centralized config via `DJANGO_ADMIN_FORGE`  
- No need to override templates for common use cases  

Example:

```python
DJANGO_ADMIN_FORGE = {
    "brand_name": "Forge Admin",
    "accent_color": "green",
    "default_theme": "system",
}
```

Copying templates just to change a color shouldn’t be the default workflow.

#### UI/UX as a first-class concern

Focused on real usability improvements:

- Sidebar navigation with search  
- Command/search bar in header  
- Collapsible layout  
- Improved changelist and forms  
- Meaningful empty states (instead of existential ones)  

#### Theming that doesn’t fight you

- Light, dark, and system themes  
- Configurable accent colors  
- Branding support (logo, tagline, identity)  

Making internal tools feel like actual products.

* * *

### Key engineering challenges & trade-offs

#### Extending Django Admin without breaking it

- **Challenge:** Django admin is powerful but tightly coupled  
- **Approach:** Hook into `AdminSite` cleanly instead of rewriting behavior  

Goal: enhance, not fight the framework.

#### Balancing flexibility vs simplicity

- **Challenge:** Make it customizable without becoming another framework  
- **Trade-off:** Opinionated defaults with controlled extension points  

#### Template overrides vs maintainability

- **Challenge:** Django admin relies heavily on templates  
- **Approach:** Strategic overrides instead of full replacement  

Avoided the “upgrade Django → everything breaks” experience.

#### UX improvements without performance cost

- **Challenge:** Rich UI (search, dashboards, filters) vs admin responsiveness  
- **Approach:** Lightweight enhancements, minimal overhead  

* * *

### Core capabilities

#### Modern admin interface

- Clean layout with collapsible sidebar  
- Sidebar search and navigation tabs  
- Header command/search bar  

#### Dashboard & analytics

- Configurable KPI cards powered by your models  
- Simple query-based metrics  
- Extensible for future analytics  

#### Improved data management

**Enhanced changelist:**

- Filters modal  
- Bulk actions  
- Better empty states  

**Improved change forms:**

- Cleaner layout  
- Better usability  

#### Customization & branding

- Config-driven branding (name, logo, tagline)  
- Theme system (light/dark/system)  
- Accent color tokens  
- Menu icons and navigation control  

* * *

### Impact & use case

- Reduces friction in day-to-day admin usage  
- Improves internal tooling experience for teams  
- Saves time otherwise spent customizing Django admin manually  
- Makes Django admin viable for more polished production environments  

* * *

### What’s next

- Expand analytics capabilities beyond simple counts  
- Improve extensibility for custom components  
- Add richer interactions to the command bar  
- Continue refining UI/UX based on real-world usage  

* * *

### Links

- **PyPI:** [django-admin-forge](https://pypi.org/project/django-admin-forge/)

</div>
