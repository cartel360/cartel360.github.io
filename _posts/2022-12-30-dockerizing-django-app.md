---
layout: post
title: Dockerizing Django Application
date: 2023-01-01 00:00:00 
description: Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package.
image:
    path: /assets/img/dockerize-django.png 
tags: [Productivity, Docker, Django] # add tag
categories: [DevOps]
published: true
---

Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package.

Django is a popular Python web framework for building web applications. In this article, we will look at how to dockerize a Django application.

Before we begin, make sure that you have Docker installed on your machine. You can follow the official installation instructions for your operating system.

## Setting up a Django Project

Step 1: Create a Django Project

The first step is to create a new Django project. Open a terminal and navigate to the directory where you want to create your project. Then, run the following command:
```bash
django-admin startproject myproject
```
This will create a new Django project with the name myproject.

Step 2: Create a Django App

Next, we will create a Django app within our project. In the terminal, navigate to the project directory and run the following command:
```bash
python manage.py startapp myapp
```
This will create a new Django app with the name myapp.

Step 3: Add a View and URL

Next, we will add a view and URL to our Django app. Open the myapp/views.py file and add the following code:
```python
# views.py 

from django.shortcuts import render

def home(request):
    return render(request, 'home.html')
```
This creates a view called home that renders a template called home.html.

Next, open the myapp/urls.py file and add the following code:
```python
# urls.py 

from django.urls import path

from . import views

urlpatterns = [
    path('', views.home, name='home'),
]
```
This adds a URL pattern that maps the / URL to the home view.

Step 4: Create a Template

Next, we will create a template for our view. In the myapp directory, create a new directory called templates. Then, create a new file called home.html within the templates directory and add the following code:
```html
<h1>Welcome to my Django app!</h1>
```
This is a simple HTML template that displays a heading.

Step 5: Create a Dockerfile

Next, we will create a Dockerfile for our Django app. A Dockerfile is a text file that contains instructions for building a Docker image.

Create a new file called Dockerfile in the root directory of your Django project and add the following code:
```dockerfile
FROM python:3.8

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Run the Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```
This Dockerfile uses the Python 3.8 base image and installs the dependencies specified in the requirements.txt file. It then copies the rest of the code into the working directory and runs the Django server

## Pushing the Image to Docker Hub
To push the image to Docker Hub, you will first need to create an account on Docker Hub and log in.

Once you have an account and are logged in, open a terminal and navigate to the root directory of your Django project. Then, build the Docker image using the following command:
```bash
docker build -t <username>/<image-name>:<tag> .
```
Replace <username> with your Docker Hub username, <image-name> with the name you want to give your image, and <tag> with a version tag for your image (e.g. latest).

For example, if your Docker Hub username is johndoe and you want to name your image mydjangoapp, you would run the following command:
```bash
docker build -t johndoe/mydjangoapp:latest .
```
This will build the Docker image using the instructions in the Dockerfile.

Once the image is built, you can push it to Docker Hub using the following command:
```bash
docker push <username>/<image-name>:<tag>
```
Replace <username>, <image-name>, and <tag> with the same values as before.

For example:
```bash
docker push johndoe/mydjangoapp:latest
```
This will push the Docker image to your Docker Hub repository. Other users will be able to pull and run the image from Docker Hub by using the following command:
```bash
docker pull <username>/<image-name>:<tag>
```
They can then run the image using the following command:
```bash
docker run -p 8000:8000 <username>/<image-name>:<tag>
```
This will run the Docker image and map port 8000 on the host machine to port 8000 on the container. The Django app will be accessible at http://localhost:8000.