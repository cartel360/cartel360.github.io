---
layout: post
title: OAuth2 Client in Django
date: 2023-01-01 00:00:00 
description: OAuth 2.0  stands for “Open Authorization”, is a standard designed to allow a website or application to access resources hosted by other web apps on behalf of a user..
img: oauth2-django.png 
tags: [Productivity, Software, Django] # add tag
published: false
---

## What is OAuth 2.0
**OAuth 2.0**  stands for “Open Authorization”, is a standard designed to allow a website or application to access resources hosted by other web apps on behalf of a user.

OAuth 2.0 uses access tokens which is a piece of data that represents the authorization to access resources. Oauth doesn't define a specific format for Access Tokens though in some cases the JSON Web Token(JWT) is often used.

To read more on OAuth 2.0 you can go through this [link](https://auth0.com/intro-to-iam/what-is-oauth-2)

## Implementing OAuth 2.0 with Django
For this article I take it you have basics of django. We will start by creating a django app that we can use to see the implementation.

Setup your virtual environment and setup up your project. 

### Installing required libraries

We will be using a python library called **Authlib** to build the OAuth client.
To install Authlib and requests we will do that by running:
```bash
pip install authlib requests
```
We will also need a library called **python-dotenv** which will help us in setting up environment variables. To install python-dotenv we will run:
```bash
pip install python-dotenv
```
We will also need a library called **certifi** that is used for validating the trustworthiness of SSL certificates while verifying the identity of TLS hosts. We can install certifi by running:
```bash
pip install certifi
```

Create a new file within the project level and name it **.env** and add the following:
```bash
TOOLKIT_SERVER_CLIENT_ID
TOOLKIT_SERVER_CLIENT_SECRET
```
Check the installed CA bundle path which was installed when we installed certifi. We can check that by running the following command:
```bash
py -m certifi
```
You should see an output that looks like:
```bash
..... .venv\lib\site-packages\certifi\cacert.pem
```

### Creating an app
Create an app and name it web and add it into the list of installed apps in settings.py
```bash
py manage.py startapp web
```
Open **settings.py** and updfate it as following:
```python
# settings.py 

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "web" # add this line
]
```
Open **models.py** in the app directory and add the following:
```python
# models.py

from django.db import models
from django.contrib.auth.models import AbstractUser

class CustomUser(AbstractUser):
    is_token_user = models.BooleanField(default=False)
    provider = models.CharField(max_length=50, null=True, blank=True)


class OAuth2Token(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)
    access_token = models.CharField(max_length=255)
    refresh_token = models.CharField(max_length=255)
    expires_in = models.DateTimeField()
    expires_at = models.IntegerField(blank=True, null=True)
    token_type = models.CharField(max_length=255)

    def __str__(self):
        return self.user.username
    
    def to_token(self):
        return {
            "access_token": self.access_token,
            "refresh_token": self.refresh_token,
            "expires_in": self.expires_in,
            "expires_at": self.expires_at,
            "token_type": self.token_type,
        }
```
Open **admin.py** and add the following:
```python
from django.contrib import admin
from .models import CustomUser, OAuth2Token
from django.contrib.auth.admin import UserAdmin

class UserAdmin(UserAdmin):
    # model = CustomUser
    list_display = ('email', 'username')
    search_fields = ('email', 'username')
    readonly_fields = ('date_joined', 'last_login')

class OAuth2TokenAdmin(admin.ModelAdmin):
    list_display = ('user', 'name', 'access_token', 'expires_at', 'token_type')
    search_fields = ('user', 'name', 'access_token', 'expires_at', 'token_type')
    readonly_fields = ('user', 'name', 'access_token')

admin.site.register(CustomUser, UserAdmin)
admin.site.register(OAuth2Token, OAuth2TokenAdmin)
```
In the above code we are registering our models so that we can be able to view then from the django admin site.

The, we need to instruct django on which model to use for authentication since we have added a custom user model. For this, we will need to edit **settings.py** file and add the following linw of code:
```python
# settings.py 
...

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

AUTH_USER_MODEL = "web.CustomUser" # add this line
```

We can now execute our migrations:
```bash
py manage.py makemigrations
py manage.py migrate
```
We then need to create some functions in **views.py** in our app directory that will be responsible for fetching the token and updating the token. Open the _views.py_ file and add the following code:
```python
# views.py

from django.shortcuts import render
from .models import CustomUser, OAuth2Token
from authlib.integrations.django_client import OAuth
from django.http import HttpResponse

def fetch_token(request, name):
    token = OAuth2Token.objects.get(user=request.user, name=name)
    return token.to_token()

def update_token(request, name, token, refresh_token=None, access_token=None):
    if refresh_token:
        item = OAuth2Token.objects.get(name=name, refresh_token=refresh_token)
    elif access_token:
        item = OAuth2Token.objects.get(name=name, access_token=access_token)
    else:
        return HttpResponse("No token found")
    
    # update token
    item.access_token = token["access_token"]
    item.refresh_token = token["refresh_token"]
    item.expires_at = token["expires_at"]
    item.save()

    # initialize OAuth client
    oauth = OAuth(fetch_token=fetch_token, update_token=update_token)
    oauth.register(
        name='toolkit',
    )
```











