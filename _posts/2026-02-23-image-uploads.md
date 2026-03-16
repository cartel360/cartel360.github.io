---
title: "A Practical Guide to File Uploads (Images, Excel, CSV) in Angular + Django"
categories: [Web Development, Full Stack, Django, Angular]
image: /assets/img/file-uploads.png
tags: [File Uploads, Angular, Django, REST Framework, CSV, Excel, Images]
description: A comprehensive guide to implementing file uploads for images, CSV, and Excel files using Angular on the frontend and Django with Django REST Framework on the backend, covering validation, security, and best practices.
mermaid: true
---
File uploads are one of those features that look simple… until they aren’t.

Images need previewing. CSV files need parsing. Excel files need validation. Large files need handling. And suddenly your "simple upload" becomes a full feature.

In this guide, we’ll build a practical and production-ready file upload system using:

* Angular (Frontend)
* Django + Django REST Framework (Backend)

We’ll cover:

1. Image uploads with preview
2. CSV uploads and parsing
3. Excel uploads and processing
4. Validation and security best practices

---

# Backend Setup (Django + DRF)

## 1. Install Dependencies

```bash
pip install djangorestframework pillow openpyxl pandas
```

* `pillow` → Image processing
* `openpyxl` → Excel support
* `pandas` → CSV & Excel parsing

---

## 2. Configure Media Files

### settings.py

```python
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
```

### urls.py (project level)

```python
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    # your urls
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

---

# Part 1: Image Upload

## Django Model

```python
from django.db import models

class Profile(models.Model):
    name = models.CharField(max_length=100)
    image = models.ImageField(upload_to='profiles/')
```

---

## Serializer

```python
from rest_framework import serializers
from .models import Profile

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = '__all__'
```

---

## View

```python
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status

class ProfileUploadView(APIView):
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request):
        serializer = ProfileSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
```

---

# Angular Frontend (Image Upload)

## HTML

```html
<input type="file" (change)="onFileSelected($event)" accept="image/*" />
<img *ngIf="previewUrl" [src]="previewUrl" width="200" />
<button (click)="upload()">Upload</button>
```

---

## Component

```typescript
selectedFile!: File;
previewUrl: string | ArrayBuffer | null = null;

onFileSelected(event: any) {
  this.selectedFile = event.target.files[0];

  const reader = new FileReader();
  reader.onload = () => {
    this.previewUrl = reader.result;
  };
  reader.readAsDataURL(this.selectedFile);
}

upload() {
  const formData = new FormData();
  formData.append('name', 'Billy');
  formData.append('image', this.selectedFile);

  this.http.post('http://localhost:8000/api/upload/', formData)
    .subscribe(res => console.log(res));
}
```

---

# Part 2: CSV Upload and Parsing

## Django View for CSV

```python
import pandas as pd
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser

class CSVUploadView(APIView):
    parser_classes = [MultiPartParser]

    def post(self, request):
        file = request.FILES['file']

        if not file.name.endswith('.csv'):
            return Response({'error': 'Invalid file type'}, status=400)

        df = pd.read_csv(file)

        # Example processing
        total_rows = len(df)
        columns = list(df.columns)

        return Response({
            'rows': total_rows,
            'columns': columns
        })
```

---

# Angular CSV Upload

```typescript
uploadCSV(file: File) {
  const formData = new FormData();
  formData.append('file', file);

  this.http.post('http://localhost:8000/api/upload-csv/', formData)
    .subscribe(res => console.log(res));
}
```

---

# Part 3: Excel Upload (.xlsx)

## Django View for Excel

```python
class ExcelUploadView(APIView):
    parser_classes = [MultiPartParser]

    def post(self, request):
        file = request.FILES['file']

        if not file.name.endswith('.xlsx'):
            return Response({'error': 'Invalid file type'}, status=400)

        df = pd.read_excel(file)

        summary = {
            'rows': len(df),
            'columns': list(df.columns)
        }

        return Response(summary)
```

---

# Validation & Security Best Practices

## 1. Limit File Size

In settings.py:

```python
DATA_UPLOAD_MAX_MEMORY_SIZE = 5242880  # 5MB
```

---

## 2. Validate File Type Properly

Don’t rely only on extension.

```python
if file.content_type not in ['image/jpeg', 'image/png']:
    return Response({'error': 'Invalid image format'}, status=400)
```

---

## 3. Rename Uploaded Files

```python
import uuid

def upload_to(instance, filename):
    ext = filename.split('.')[-1]
    return f"uploads/{uuid.uuid4()}.{ext}"
```

---

## 4. Handle Large Files with Streaming

For very large CSV files, process in chunks:

```python
for chunk in pd.read_csv(file, chunksize=1000):
    # process chunk
    pass
```

---

# Bonus: Returning Processed Data

Sometimes you don’t just upload — you process and return a result file.

Example: Generate processed CSV

```python
from django.http import HttpResponse

response = HttpResponse(content_type='text/csv')
response['Content-Disposition'] = 'attachment; filename="processed.csv"'
df.to_csv(response, index=False)
return response
```


# Final Thoughts

File uploads are not just about saving files.

They are about:

* Validation
* Security
* User experience
* Scalability

When done correctly, they become powerful data pipelines inside your application.

If you’re building admin systems, reporting tools, learning platforms, or fintech dashboards — mastering uploads is essential.
