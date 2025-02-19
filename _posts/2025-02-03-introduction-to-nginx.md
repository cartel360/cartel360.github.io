---
layout: post
title: Introduction to Nginx
date: 2025-02-03 00:00:00
categories: [Software Development]
image:
  path: /assets/img/nginx.jpeg
tags: [Nginx]
description: Nginx has emerged as one of the most popular and powerful web servers in recent years, renowned for its exceptional performance, scalability, and versatility. This comprehensive guide aims to provide you with a solid understanding of Nginx and its role in web server configuration and optimization
published: true
canonical_url: https://blogs.innova.co.ke/introduction-to-nginx/
---


Nginx has emerged as one of the most popular and powerful web servers in recent years, renowned for its exceptional performance, scalability, and versatility. This comprehensive guide aims to provide you with a solid understanding of Nginx and its role in web server configuration and optimization. Whether you are a seasoned developer or just starting with web server administration, this article will take you through the essential concepts and techniques necessary to master Nginx. From installation and basic configuration to advanced optimization strategies, load balancing, caching, SSL/TLS configuration, and more, this guide will equip you with the knowledge and skills needed to harness the full potential of Nginx in your web development projects. So, let's dive in and embark on a journey to become proficient in Nginx and elevate your web server performance to new heights.

Think of when trying to access a given site, the typical way of how you'd envision the process being will be like shown below, where you access the site form your PC and it makes the request to the server and it returns the data you need. 

![][image_ref_aeqqm09i]


From the above diagram the in process there isn't much going on, and it will work fine if at all the site is not receiving so much traffic, so think of a situation whereby your site is receiving so many requests at a go and your server is not in a position to handle all those requests, that's where Nginx can help, because with this it will give you the flexibility of increasing more servers to be able to handle all the requests. The diagram below shows where Nginx will be located.

![][image_ref_w2eykse0]


## Introduction to Nginx: Understanding its Role in Web Server Configuration

### What is Nginx?
Nginx, pronounced "engine-x", is a powerful web server and reverse proxy server that has gained popularity for its high performance and scalability. It is designed to efficiently handle a large number of concurrent connections and process web requests at lightning speed.

### Advantages of Nginx
There are several advantages to using Nginx as your web server. Firstly, it has a small memory footprint, which means it can handle more simultaneous connections without consuming excessive system resources. Additionally, Nginx excels at serving static content, making it ideal for delivering images, videos, and other media files. It also supports various advanced features like load balancing, caching, and SSL/TLS encryption.

### Nginx vs. Other Web Servers
When comparing Nginx to other web servers like Apache, one key distinction is how they handle concurrency. Apache follows a process-based model where each connection spawns a new process, while Nginx uses an event-driven model that allows it to handle multiple connections more efficiently. This difference in architecture gives Nginx a performance edge in high-traffic scenarios.

## Setting Up Nginx: Installation and Basic Configuration

### Installing Nginx
Getting Nginx up and running is a breeze. Simply use your package manager to install Nginx, and you'll be ready to go. Whether you're on Linux, macOS, or Windows, there are easy-to-follow installation instructions available for your specific operating system.

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install nginx
```

After installation, NGINX will automatically start in the background. To check the status, run:
```bash
sudo systemctl status nginx
```

#### MacOS
```bash
brew install nginx
```
After installation, you can run it using:

```bash
brew services start nginx
```

#### Windows
Download the latest stable version of NGINX from the official website: [nginx: download](https://nginx.org/en/download.html)

Extract the downloaded zip file to a location of your choice.

Navigate to the NGINX directory and run nginx.exe. NGINX should start.


### Nginx Configuration Files
Once Nginx is installed, it's time to dive into the configuration files. Nginx uses a simple and intuitive configuration syntax, with the main configuration file typically located at /etc/nginx/nginx.conf. This file allows you to customize various server settings, define server blocks, and specify rules for handling different types of requests.

Example of a Basic `nginx.conf` file

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    sendfile on;
    keepalive_timeout 65;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

This configuration sets up basic parameters like the user, worker processes, logging, and includes additional configuration files from the `conf.d` and sites-enabled directories.


### Basic Nginx Server Block Configuration
Nginx uses server blocks to define different virtual hosts or websites on a single server. Each server block specifies the server name, listens on a specific port, and defines the document root directory. By setting up multiple server blocks, you can host multiple websites or applications on a single Nginx instance, making it a versatile web server.

Example of a Server Block


```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    root /var/www/example.com;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    error_page 404 /404.html;
    location = /404.html {
        internal;
    }
}
```

This server block listens on port 80 for requests to `example.com` or `www.example.com`, serves files from the `/var/www/example.com` directory, and handles 404 errors with a custom error page.

## Advanced Nginx Configuration: Optimizing Performance and Security

### Understanding Nginx Directives
To unlock the full potential of Nginx, it's essential to understand its directives. Directives are instructions that control various aspects of Nginx's behavior. From basic directives like "listen" and "root" to more advanced ones like "gzip" for compression and "proxy_pass" for reverse proxying, mastering these directives will allow you to fine-tune Nginx for optimal performance and security.

#### Example Directives
- `gzip`: Enables compression to reduce response sizes.

```nginx
gzip on;
gzip_types text/plain text/css application/json application/javascript;
```

- `proxy_pass`: Used for reverse proxying to backend servers.

```nginx

location /api/ {
    proxy_pass http://backend_server;
}
```


### TCP and HTTP Load Balancing
Load balancing is a crucial feature of Nginx that allows distribution of incoming network traffic across multiple backend servers. Whether you need to balance TCP connections for database servers or HTTP requests for web applications, Nginx provides easy-to-configure load balancing options to improve performance, maximize resource utilization, and ensure high availability.

Example of HTTP Load Balancing

```nginx
http {
    upstream backend {
        server 192.168.1.101;
        server 192.168.1.102;
        server 192.168.1.103;
    }

    server {
        listen 80;
        server_name example.com;

        location / {
            proxy_pass http://backend;
        }
    }
}
```
This configuration distributes HTTP requests across three backend servers using a round-robin algorithm.


### TLS/SSL Configuration
Securing your website with SSL/TLS encryption is essential for protecting sensitive user data and establishing trust. Nginx offers robust TLS/SSL configuration options, allowing you to generate or upload SSL certificates, enforce HTTPS, and customize SSL protocols and ciphers to enhance security, all without breaking a sweat.

Example of SSL Configuration

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/nginx/ssl/example.com.crt;
    ssl_certificate_key /etc/nginx/ssl/example.com.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    root /var/www/example.com;
    index index.html;
}
```

This configuration enables HTTPS on port 443, specifies the SSL certificate and key, and restricts protocols and ciphers for enhanced security.

### Configuring Access Control and Security Features
Nginx provides several features to safeguard your web server and applications. From access control using IP whitelisting or blacklisting to protecting against common web attacks like DDoS and SQL injection, Nginx's built-in security modules and third-party extensions make it a formidable shield against malicious actors.

Example of IP Whitelisting

```nginx
location /admin {
    allow 192.168.1.0/24;
    deny all;
}
```

This configuration restricts access to the `/admin` location to IPs in the `192.168.1.0/24` range.


## Load Balancing and High Availability with Nginx

### Understanding Load Balancing and High Availability Concepts
Load balancing and high availability are essential components of a scalable and reliable web infrastructure. Load balancing ensures even distribution of traffic across multiple servers, while high availability ensures continuous availability of services even in the event of server failures. Understanding these concepts will help you design robust and resilient systems.

### Configuring Nginx as a Load Balancer
Nginx can operate as a highly efficient load balancer, enabling you to distribute incoming requests across multiple backend servers. Whether you choose a simple round-robin approach or more advanced load balancing algorithms, Nginx's configuration options make it easy to scale your web applications and handle heavy traffic with ease.

Example of Advanced Load Balancing with Health Checks

```nginx
http {
    upstream backend {
        least_conn;
        server 192.168.1.101 max_fails=3 fail_timeout=30s;
        server 192.168.1.102 max_fails=3 fail_timeout=30s;
        server 192.168.1.103 max_fails=3 fail_timeout=30s;

        health_check interval=10s uri=/health;
    }

    server {
        listen 80;
        server_name example.com;

        location / {
            proxy_pass http://backend;
        }
    }
}
```

This configuration uses the `least_conn` algorithm, performs health checks every 10 seconds, and marks servers as unhealthy after 3 failures.

### Implementing High Availability with Nginx
To achieve high availability, Nginx can be configured with backup servers, failover mechanisms, and health checks to ensure constant availability of your services. By setting up redundant systems and implementing smart monitoring, Nginx can automatically redirect traffic to healthy servers, minimizing downtime and providing a seamless user experience.

Example of Failover Configuration

```nginx
upstream backend {
    server 192.168.1.101;
    server 192.168.1.102 backup;
}
```

In this setup, `192.168.1.102` acts as a backup server and will only receive traffic if the primary server (`192.168.1.101`) is unavailable.


## Nginx Caching: Boosting Website Speed and Efficiency

### Introduction to Caching

Caching is like having a super-smart assistant that anticipates your needs and retrieves things for you before you even ask. In the world of web servers, caching is a game-changer when it comes to boosting website speed and efficiency. It involves storing frequently accessed data, such as HTML pages, images, or API responses, in a temporary storage area (cache). This allows subsequent requests for the same content to be served quickly without having to regenerate or fetch the data from the backend server. By reducing the load on your server and minimizing response times, caching significantly improves the user experience and scalability of your website.

---

### Configuring Nginx Caching

Configuring Nginx caching is easier than deciding what to order for dinner (well, almost). With just a few lines of code in your Nginx configuration file, you can enable caching and start reaping the benefits. Nginx provides powerful caching mechanisms that can be customized to suit your specific needs.

#### Basic Caching Configuration

To enable caching in Nginx, you need to define a **cache zone** and configure how and where the cached data should be stored. Here's a basic example:

```nginx
http {
    # Define a cache zone named 'my_cache' with 10MB of shared memory
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m use_temp_path=off;

    server {
        listen 80;
        server_name example.com;

        location / {
            proxy_cache my_cache;  # Enable caching for this location
            proxy_cache_valid 200 302 10m;  # Cache 200 and 302 responses for 10 minutes
            proxy_cache_valid 404 1m;       # Cache 404 responses for 1 minute
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;

            proxy_pass http://backend_server;  # Forward requests to the backend server
        }
    }
}
```

In this configuration:
- `proxy_cache_path` defines the cache directory (`/var/cache/nginx`), the cache zone (`my_cache`), and its size (`10m` for 10MB of shared memory).
- `proxy_cache` enables caching for the specified location.
- `proxy_cache_valid` sets the caching duration for different HTTP status codes.
- `proxy_cache_use_stale` allows serving stale content in case of backend errors or timeouts.

#### Cache Purging

Sometimes, you may need to clear the cache to serve fresh content. Nginx supports cache purging using the `proxy_cache_purge` directive (requires the `ngx_cache_purge` module).

```nginx
location /purge {
    allow 127.0.0.1;  # Restrict purge requests to localhost
    deny all;         # Deny purge requests from other IPs
    proxy_cache_purge my_cache $scheme$proxy_host$request_uri;
}
```

This configuration allows you to purge cached content by sending a request to `/purge` with the URL of the content you want to remove.

#### Fine-Tuning Cache Behavior

You can further optimize caching by configuring additional directives:

- **Cache Key Customization**: Customize the cache key to include specific request attributes.
  ```nginx
  proxy_cache_key $scheme$proxy_host$request_uri$cookie_user;
  ```

- **Bypassing Cache**: Conditionally bypass the cache for specific requests.
  ```nginx
  location /dynamic-content {
      proxy_cache_bypass $cookie_nocache;  # Bypass cache if 'nocache' cookie is set
      proxy_no_cache $cookie_nocache;      # Do not cache responses if 'nocache' cookie is set
      proxy_pass http://backend_server;
  }
  ```

- **Cache Locking**: Prevent multiple requests from regenerating the same cache entry simultaneously.
  ```nginx
  proxy_cache_lock on;
  proxy_cache_lock_timeout 5s;
  ```

#### Example: Full Caching Configuration

Here’s a complete example of an Nginx caching configuration:

```nginx
http {
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m use_temp_path=off;

    server {
        listen 80;
        server_name example.com;

        location / {
            proxy_cache my_cache;
            proxy_cache_valid 200 302 10m;
            proxy_cache_valid 404 1m;
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
            proxy_cache_key $scheme$proxy_host$request_uri;
            proxy_cache_lock on;
            proxy_cache_lock_timeout 5s;

            proxy_pass http://backend_server;
        }

        location /purge {
            allow 127.0.0.1;
            deny all;
            proxy_cache_purge my_cache $scheme$proxy_host$request_uri;
        }
    }
}
```

---

### Benefits of Nginx Caching

1. **Improved Performance**: Caching reduces the load on your backend servers and decreases response times for users.
2. **Scalability**: By serving cached content, Nginx can handle more concurrent requests without overloading your infrastructure.
3. **Cost Efficiency**: Reduced server load translates to lower hosting costs, especially for high-traffic websites.
4. **Enhanced User Experience**: Faster page loads lead to happier users and better SEO rankings.

---

Nginx caching is a powerful tool for optimizing website performance and efficiency. By configuring caching properly, you can significantly reduce server load, improve response times, and provide a better experience for your users. Whether you're running a small blog or a high-traffic e-commerce site, Nginx caching is a must-have feature in your web server setup.


Yes, the section on SSL/TLS configuration is necessary and highly relevant, as securing web applications is a critical aspect of modern web development. Below is a revised and improved version of the content, with better flow and clarity:

---

## SSL/TLS Configuration with Nginx: Enhancing Security for Web Applications

### 6.1 Understanding SSL/TLS

In today’s digital landscape, where cyber threats and data breaches are rampant, securing your web applications is no longer optional—it’s essential. This is where **SSL/TLS** (Secure Sockets Layer/Transport Layer Security) comes into play. But what exactly are SSL and TLS, and why are they so important?

SSL and TLS are cryptographic protocols designed to secure communication over the internet. They encrypt data transmitted between a user’s browser and your web server, ensuring that sensitive information like login credentials, payment details, and personal data remain private and protected from eavesdroppers.

#### Key Concepts:
- **Encryption**: SSL/TLS encrypts data to prevent unauthorized access.
- **Certificates**: SSL/TLS relies on digital certificates to verify the identity of the server and establish a secure connection.
- **HTTPS**: When SSL/TLS is enabled, your website uses HTTPS (Hypertext Transfer Protocol Secure) instead of HTTP, indicated by a padlock icon in the browser’s address bar.

By implementing SSL/TLS, you not only protect your users’ data but also build trust and improve your website’s credibility. In the following sections, we’ll guide you through generating SSL certificates and configuring Nginx to enable SSL/TLS.

---

### 6.2 Generating SSL Certificates

Before you can enable SSL/TLS on your website, you’ll need an **SSL certificate**. These digital certificates act as credentials that verify your server’s identity and enable encrypted communication. While purchasing certificates from commercial providers is an option, you can also obtain free, trusted certificates from **Let’s Encrypt**, a widely used certificate authority.

#### Steps to Generate SSL Certificates with Let’s Encrypt:
1. **Install Certbot**: Certbot is a tool that automates the process of obtaining and installing SSL certificates.
   ```nginx
   sudo apt update
   sudo apt install certbot python3-certbot-nginx
   ```

2. **Obtain a Certificate**: Run Certbot to generate a certificate for your domain.
   ```nginx
   sudo certbot --nginx -d example.com -d www.example.com
   ```

3. **Verify the Certificate**: Certbot will automatically configure Nginx to use the certificate. You can verify its installation by visiting `https://example.com` and checking for the padlock icon in the browser.

4. **Auto-Renewal**: Let’s Encrypt certificates are valid for 90 days. Certbot automatically sets up a cron job to renew the certificates before they expire.
   ```nginx
   sudo certbot renew --dry-run
   ```

With your SSL certificates ready, you’re all set to configure Nginx for secure communication.

---

### 6.3 Configuring Nginx for SSL/TLS

Now that you have your SSL certificates, it’s time to configure Nginx to enable SSL/TLS for your web applications. This involves modifying your Nginx configuration file to:
1. Enable HTTPS.
2. Redirect HTTP traffic to HTTPS.
3. Strengthen security by using modern protocols and ciphers.

#### Example Nginx SSL/TLS Configuration:
```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    # Redirect all HTTP traffic to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name example.com www.example.com;

    # SSL Certificate and Key
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # Enable modern TLS protocols
    ssl_protocols TLSv1.2 TLSv1.3;

    # Optimize cipher suites for security and performance
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_prefer_server_ciphers on;

    # Enable HSTS (HTTP Strict Transport Security)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Root directory and default file
    root /var/www/example.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

#### Key Configuration Directives:
- **`listen 443 ssl`**: Enables HTTPS on port 443.
- **`ssl_certificate` and `ssl_certificate_key`**: Specify the paths to your SSL certificate and private key.
- **`ssl_protocols`**: Restricts TLS protocols to secure versions (e.g., TLSv1.2 and TLSv1.3).
- **`ssl_ciphers`**: Defines secure cipher suites for encryption.
- **`Strict-Transport-Security`**: Enforces HTTPS for all future requests.

#### Redirecting HTTP to HTTPS:
The first server block listens on port 80 (HTTP) and redirects all traffic to HTTPS using a `301` permanent redirect. This ensures that users always access your site securely.

---

### 6.4 Testing and Verifying Your SSL/TLS Configuration

After configuring SSL/TLS, it’s important to test your setup to ensure everything is working correctly. You can use tools like **SSL Labs’ SSL Test** or **Qualys SSL Server Test** to analyze your configuration and identify potential vulnerabilities.

#### Common Checks:
- Ensure the padlock icon appears in the browser.
- Verify that HTTP traffic is redirected to HTTPS.
- Confirm that outdated protocols like SSLv2 and SSLv3 are disabled.

---

Enabling SSL/TLS on your Nginx server is a critical step in securing your web applications and protecting user data. By generating SSL certificates and configuring Nginx to use HTTPS, you not only enhance security but also improve user trust and compliance with modern web standards. With the steps outlined in this guide, you can easily set up and optimize SSL/TLS for your website, ensuring a safe and seamless experience for your users.



[image_ref_w2eykse0]: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAIcBAADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD3+iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiikJABJ6CgBaK4XQfiNBrXjG70TyFSNCwgm3f6wr14rtzJGrbWdQxGcE0APopqSJIMo6sB3Bpv2iHGfNTGcZ3CgCSik64IPFLQAUU3em/ZuG70zzSkgDJOAKAFopA6su5WBHqDTfNjwD5i4PQ5oAfRSb1K7tw2+ueKQOpXcGBX1zxQA6ikDqy7lYFfUGmiSM4w6nPTnrQA+iml0D7Sw3HtnmnUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXOeOdaXQvCV9dF9sjRmOPnkseOK6OuP8aeGNQ8T32kwo8K6dbzebcKx5fHQAfn+dAHlj3ukaNoXhzUbDULeXVbSfzLpEb5mDdQa6nxMqa/8S9AgS6mjtbuz3MYXI3DJrutX8I6TqGjXNlHYW0byRlEcRgFT2Oa8qfRvEOneNPDumfa7ZNRt7ZhDLjcpUMcA/yoA3RaHwd8SLTTbC4naw1C3fdDJIWCkA8is3wN4Vt/EuiarPfXd2XjndYQspAjPPIrq9O8JaxL4ik8ReI7uCW4hhaO3igHyrkHmuR8BWfii40XU10O8tY4Zbl0dZl5U+oNAHYfCvVLu80C5tL2ZppLK5aBZHOSwFdnqX2n+zLr7Hj7T5TeVn+9jisfwb4YXwroYszL507uZJpP7zGtnULX7dp89qJHiMqFQ6HBU+ooA8Kt0tlhddd1PV9K8QGXP2qYt5Wc9u2K2/GevyvrOj6De6hcGx+zrNcz2YJac+2O1aN14O8Z3elHQbm9sLiwJx9qlXM23P8AOtLVvAF2g0m90O7jj1LTohCDOMrIo7GgDmND1P7H4lurLSJNRfSLq0kJW6Vx5bhSeCfpU3w68Lx694Zlv72+vZZvMlSJDMdqcn3rrdN0nxZcS3Mus3VikbQNFHb2yDBJHUnFWvAHh288M+HjY3zRtMZnfMZyME5oA87TXruy+GeoaE08n9pQ3n2FCWO87jnPrUniS8bT9Q0TwtdXl5Dp8Vqst0bfc0kjEZxxzXSXfw6mn+JKa6rx/wBmswlli3cmQDAOK1PFfhG81HWLPXdGuY4NTtV2YlGUkX0NAHEaBqZs/Et9Y6VLqMmj3FlI2LpWHluAehNaHwz0Fr/QF1uW8upryKRxbxvKdiHHp36102n6R4quJLuXWLqxWN7doo7e3j43EdSal8F+GLvRPCD6RfyKsrs+XgboD6H1oA8vj8pReJ4mvtX03W3mJiun3+SozxjtivbtD8z+xLPzLxbxvKX/AEheknHWvPrjwf4zfS7jQmvdPu9PmJAubgFpVU/XvXfeH9IXQtCs9MWQyC3jClz3PegDTooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACsyfQNOudbt9Ylg3X1umyOTPQVp0UAIyh0KtyCMGs7RtB07QIJIdOg8mORy7DOck1pUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFRXNzDZ20lxO4SKMZZj2rzi+8davrN61n4ctWCg48wrlj7+gpNmc6kYbnplFeYro3j+Vd5vwhPJDSDI/JaX+wvH3/QST/v5/wDY0XI9s/5H/XzPTaK8y/sPx9/0Ek/7+f8A2NH9iePv+gin/fz/AOxouHtn/I/6+Z6bRXmX9iePv+gin/fz/wCxo/sTx9/0EU/7+f8A2NFw9s/5X/XzPTaK8y/sPx9/0EU/7+f/AGNH9h+Pv+gin/fz/wCxouHtn/K/6+Z6bRXmX9h+Pv8AoIp/38/+xpr6P4/iUut+GI5CrIMn8xRcPbP+R/18z0+ivMrDx3q2j3i2niK1YqTjzAuGHv6H8K9HtLuC+tY7m3kEkUgyrDvQmXCrGexNRSHODjrXGz6X42a4kaHWLVYyxKAqeB27UypO3Q7OiuI/snx1/wBBq0/75P8AhVYeJtf8NXUcXiK3Wa1kbAuYh0pXJdVL4k0egUVFb3EV1bxzwuHikUMrDoRUtM0CiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoorK1nxDpuh25lvbhVbHEYOWb8KBSkoq8matFeLeIPiTqmpO0en5s7cdCD87fj2qj4a+LOp6ZOINXze2ucbujr/AI0ro5aeNo1JOMX8zr/H15darrVp4cs8guQzjpknpn2HWuz0PQrXQtPS2t0G4cu/dj61n6Rf+G/Et3DrFm0Ul7GmAScSKD2Iro+9HmbQh7zm9b/kUNV1qw0W3Wa+mEascLxkmnaXrNjrFqbmymEkY69iPrWB428MXHiG2gNtIolhJwrHg5o8HeFp9E0y6hupf3lxwQp4XijqHNP2lrady/F4x0SfU/7PS7BmztHB2k+mas6x4i03Qo0e+n2bz8qgEk/gK4Sw+G2oW2uxzvcRfZYpN4YH5jjpxW1428IXuvzW09lJHujUqyucfjRrYhTrcjbjr0Or0/UrXVLVbmzlEsTdGFW6wPCGgy+H9G+zTyB5Xcu23oPYV0FM2i24py3EpaKKCgooooAy9c0S01vTpLa4TkjKOOqnsa4n4e6hPp+sXfh+5ckIWKA9iDz+delGvL5x5Hxcj8v5d7Atjv8AL/8AWpMwqrllGa72PUKKKKZuFVdSsINTsJrO5QNHIuDnt71aooDc4bwDcz2lzqOgXL5azfKZPbPSu5rg7P8Ad/Fe7VeA0GW9+ld5SRnT2t2CiiimaBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFQXl7bWFu091MkUS9WY4qn4g1T+xtDur8KGaJcgH17V4Lq+valrk5lvJ2fnhAflX6CpckjhxmNjhla12zvPEfxOLBrfRRtByDcMOfwFedXN3PezGa5meaRjks5yaqcg89acDWcp3Pm8Ri6td++9Owr/drn2+8frW/IfkrAP3j9alNm+A6ktnfXenXK3FncSQTKeGQ4r1jwr8XvuWuvr7C5Qcf8CFeQ4pDVpnqwqShsz61s9QtNQtlntJ0miYZDIcisXVPGmnaNdfZ72K5R+oPl5DfQ1896D4l1Pw7crLYXDKufmjJyrfUV9DaQ9l4u8O2OoXdnG/mIH2sM7T3qzup1XUVlozP/4WVoXfz/8Avij/AIWXoX/Tf/v3WyPCuiD/AJh0H/fFO/4RXQ/+gbb/APfNPUvlq33X3f8ABMT/AIWZoIH/AC3/AO/Zo/4WZoX/AE3/AO/dbf8Awiuh/wDQNt/++KP+EV0P/oG2/wD3zRqK1buvu/4Jif8ACzNC/wCm/wD37o/4WZoX/Tf/AL91t/8ACK6H/wBA23/75o/4RXQ/+gbb/wDfNGoWrd193/BMT/hZmhf9N/8Av3R/wszQv+m//futv/hFdD/6Btv/AN80f8Irof8A0Dbf/vmjULVu6+7/AIJif8LM0L/pv/37rlrbVbfWviba3tqGETMANwweFNeif8Irof8A0Dbf/vmuEks7ew+KltBaxLFGCCFXp900nczqKp7vM1uuh6nRRRVHUFFFFAHB2v8AyVm6/wCvf/Cu8rg7X/krN1/17/4V3lJGcOvqFFFFM0CiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA5rx9/yJl/8AQfzFeZ/DzTLTU9ekW7hWVY49wVumc16Z4+/5Ey/+g/mK8/8AhZ/yMNx/1x/rWctzx8bFSxdNM6Txf4HtLyxe50yBYblBu2ovDj0ryNo2jco6lWU4KkYIr2/UPE66X4sTTbkhbaaMFW/usSevtXO+PvCPmRtrGnoCQN0yr3HrSsnsc+Nw0ajc6W63RY8L+G9LufBTSzWqPLIjMXYcj6GvC5gFnkUdmI/WvozweMeBU5/5ZP8A1ry/wn8OG8VWtzqEt8II/PZEVRk8HnNHKddOj+6hyrWxT+G3hyy8R65PHfgvFBFvCDjJzjmqXj3QrXQPFE1nZkiAqHVT/DntXsPgz4fR+Eb64ukvWn86PZgrjHOar+K/hpF4n1ltRa/aFigXYFz0p2N/q75NtTwAda+lPhz/AMiLpn/XOvG/G/gd/CElqy3QninyBxggivZPhz/yIumf9c6aDDxcajTOroooqzuCiiigAooooAKKKKACvMtQ/wCSu230X/0E16bXmWof8ldtvov/AKCaTMK+0fVHptFFFM3CiiigDg7b/krFx/17/wCFd5XB23/JWLj/AK4f4V3lJGdLr6sKKKKZoFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBzXj7/kTL/wCg/mK8/wDhZ/yMFx/1x/rXoHj7/kTL/wCg/mK8Z0HxDP4c1D7XbqrkrtZGOARWczxcfNQxVOT2R0nxQbHiVMZ/1A6fU1s+AfGK3KJo2oyBpMbYmb+MeledeI/Etxr+pfa5o1jIXaqqc4FY8U8kUyyxuyyIcqwPINSpHGsS44h1Y7M+mfsUFjpc0NsoSMI5AHuDXzvb6/q2jvNHpt9Lbo0hLKuCCc+ldSPipqw0trRraJ5Suzzix/PFcE5LMWPJJyaps6cVi4yUfZaWPVPhd4j1vWNZvIdSvnuIY4gyhgBg59qofEnxhrukeKWtLC/eCERK21QOprkvDXiO68M6ibq3RZAy7XRjjIql4k1S48RavJqM4VHcBQo6AClcqGOTpqMnqVNV13U9dkjfUruS4dBhd3QV9BfDkY8C6Z/1zr5v8or1r6R+HP8AyI2m/wDXOqidmGleVzqhS0gpas7wooooAKKKKACiiigArzK//wCSu23/AAH/ANBNem15lf8A/JXbb/gP/oJpMwr7R9Uem0UUUzcKKKKAODtv+SsXH/XD/Cu8rg7b/krFx/1w/wAK7ykjKl19WFFFFM1CiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiuY1HwnaTTTXk2r6lArEuwW42qv6UEybS0Vzp6K8c1dJDHLLol9qclnCcSXc052sc4wo4zXqmiQzQaJZxXEjSTLEodmOSTigypVvaNq2wazpkes6TcWErFVmXG4dj2rwTxL4L1fw65eZDPb9poxkfj6V9FU2SNJY2jkUMjDBUjINJq4q+GhWWu58od+vSlr2zxP8LLHUd9zpJFrcnkx/wADf4V5Jq+hajodyYL+2eI9mPIb6GocbHg4jCVKTu1oUKKQGlqTktYMUhrT0jQtS12YR6fbNLzy3RR9TXrHhr4Y2Om7bnUz9quOuz+Bfw71SR1UcLUq7LQ828O+B9V8QurxwmG1J+aWQYGPYd6980XS4tG0i30+HmOFAoPrVyKNI1CooVQMAAYAqSmj3cPhlRW9wFLSClqzqCiiigAooooAKKKKACvMr/8A5K7bf8B/9BNem15lf/8AJXbb/gP/AKCaTMK+0fVHptFFFM3CiiigDg7b/krFx/1w/wAK7yuDtv8AkrFx/wBcP8K7ykjKl19WFFFFM1CiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKwtc8Sw6W62lvGbrUJeI4E5/E+goJlJRV2X9V1ey0a0a5vZljQdATyx9BXMJY6n4wmWfUfNstJBylr0aX3b2q3pfhme5uxqviCQXN5nMcOf3cPsB3NdUBgYFBHK5/Ft2/zOO8T20Jl0XQbWJY45Zw5RBwETk12AGAAO1NaGNpVlaNTIn3WI5FPoLjGzbCiiigoKqahpllqls1ve20c0bDGHXNW6KAavozyLxF8JZEdp9Dl3qTnyJDgj6GneG/hNIXW41yUKo6QR85+pr1uilyo5PqVDn5rHNWmoaLpGsW/h6zhEUhHRVwBxnk9810RFef/ELSbm3vLbxDYBhJCR5hXqMdDXR+G/FFnr9mjK6pdKP3kRPIPqPajqawmlNwenb0N0U6iig2uApaQUtMAooooAKKKKACiiigArzGZhdfF6Py+fLIDY9lrrfE/ie10GwYs4e5YERxA8k/4Vz3w70e4ea4168DeZPkR7upB6mkznqvmnGC9fuPQqKKKZ0BRRRQBwdt/wAlYuP+uH+Fd5XB23/JWLj/AK4f4V3lJGVLr6sKKKKZqFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABSMwVSzEADqTVe+v7XTbV7m7mSKJBksxrk9+qeM5CFElhowP3uQ9wP6CgiU0tFuWL7xFdarePpfh5PMccTXZHyRjvj1Namh+HLXRYy4Jnu5OZbiTlmP9BV+w0+10y1W2tIVijUdFHWrVAow15pbhRRRQaBRRRQAUUUUAFFFFABRRRQA10WRGR1DKwwQR1rgdY+HOblrvRLn7M5/wCWZOAPoR0r0CiixE6cZq0jzBdJ+IEI8uO43KvAJlXmnf2d8Q/+e4/7+JXptFKxn7BfzP7zzL+z/iH/AM9x/wB/Eo/s/wCIf/Pcf9/Fr02iiwewX8z+88y/s/4h/wDPcf8AfxaP7P8AiH/z3H/fxa9NoosHsF/M/vPMv7P+If8Az3H/AH8Wj+z/AIh/89x/38WvTaKLB7BfzP7zzL+z/iH/AM9x/wB/Fpr6V8QZkMb3G1W4JEqj+Ven0UWD2C/mf3nn2j/Dgi6W71u6a5kByIwSQfqT1rv0RY0VEUKqjAAHSnUU0rGkKcYK0UFFFFBYUUUUAcHbf8lYuP8Arh/hXeVwdt/yVi4/64f4V3lJGVLr6sKKKKZqFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFY+ueIrPRIgJN0t1JxFbxjLOfpWfq3iaWW7bStCjFzfnh5Mfu4vcn1qzonhmLTpmv7uQ3WpSD95M/b2UdhQZuTbtEoWOg3ut3Eep+Ij05isQfkT6+prrVVUUKoAUDAA7UtFBUYKOwUUUUFBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAcHbf8lYuP8Arh/hXeVwdt/yVi4/64f4V3lJGVLr6sKKKKZqFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUjMqKWYgKBkk9q4XxD8RraykNnpSfa7onaGHKg+3rQZ1asKSvNncSzRQIXmkSNR1LHArmdT8f6FpxKi4NzIP4YRmuQi8NeKvFbifV7xre3PIQ8H8F/xrqdM+H+i6eoMkJuZB/FKaSZyuvXqfwo2XdmJP8VJJJNlho8rjsWJP8hUB8c+LJxug0YAf9c2r0S30+ytVxBaxRgf3VAqxsXPShh7HEP4qn3I8xXxt4wjOZNGBA7eU1Tx/FC8t2H9oaM6LnBKkjH5ivScDHSoZrK2uEKzQRyA9mXNJJj9jXW1T8DmdO+I2hX2Flka1Y8Yl6fnXVW91b3UYkt5o5VPdGBrnNR8B6Ffq3+iCFz/FEcGuTn8F6/4dk+1aJfPIinJQHBx9Ohp3EquIpv8AeRuu6PVKK870P4jlZ1sdft2t5wcGULgD6jtXoMM0dxEssTq8bDKspyDTOmlWhVV4MfRRRQahRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUVga94v0zQUKzSeZcdoo+T+PpQKUlFXZvM6opZ2CqOpJwBXGa/8QbPT3NtpqC8ujwNp+UH+tc81x4l8cyBYgbTTm6nopH17112geC9M0VQ/l+fcDrLIP5ClvsY886nwaLv/kjmP+Ex8XlQRpHX/pmaUeMPF+OdHJ/7ZmvTAABjFGBRYfspfzv8P8jzT/hMPF3/AEBv/HDSf8Jf4v8A+gP/AOQzXpmBS0WD2cv53+H+R5l/wl/jD/oD/wDkM0f8Jf4w/wCgP/5DNem0nGM0WD2Uv53+H+R5n/wl/jD/AKA//kM02Xxn4shiMsulpHGvVmQgCum1/wAcaboyvHGwubkcBEPQ+5rlUsvEvjeXzbqRrPTzyFPAI9h3pGUrp8sZNv5f5FFvidrXQR2312mvTvD+pSatodrfSoEeVMkA8ZrivE3hTTdC8HymCPdPuGZm+8a6nwX/AMijp3/XIU1fqOiqsZ8tR30N+iiimdQUUUUAFFFFABRRRQAUUUUAFFFZusa5ZaJa+ddSYZuI4x95z6AUCbSV2Xbi4htYWmnkWONRksxwBXISajqfi6Y2+lb7PSwcSXZ+9L7LTrfStR8Uypea2Db2AO6KxB5b0L118MMdvCsUKKkajCqowBQZe9U8l+ZT0rR7PRrXyLSIKDyzH7zH1J71foooNUklZBRRRQMKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA4O2/5Kxcf9cP8K7yuDtv+SsXH/XD/AArvKSMqXX1YUUUUzUKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACoLy8t9PtZLm6lWOFBlmY1JLKkETyysFRBlmJ4ArybU9QvviD4gOm2W5NNhbJbsf9o0GFesqa01b2Q/UvEGr+OL46fpCNFYg4Z+mR6k/0rr/DXgvT9CjEmwTXR5aVxkg+1amkaHZ6LZx29rGFC/ebHLH1NalIxpYZuXtKushQoHSkIp1IxAGScYoO0SkJA6kVy954gvtRvJLDQIldoziW7k/1aew9TQPCU90A+o61eSynr5T+Wv5CgxdVt+4rnUgqehFL2rlT4PaEbrTWNQjcfd3TFx+RqOLV9V0KdY9bVZ7V22rdxjG3/eFMXtWvjVjrsUGmxypKgeNgykZBB4NPoNtGjB13wtp2vQlZ49soHyyqPmFefwXOufD3VBDPuuNLduCeePUehr13FVNR0221Sze1uo1eNxggihnLVw/2qekhNL1W01ixS7s5Q8bfmD6GrteRMmofDrxAJELy6XMcEE8Ef4ivVbG9g1CziurZw8Ui7lINBWHr+0vGWkluixRRRQdIUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABVDVNasNHtzNe3CxjsM8n6Cs7xjrFzougyXVqF83cFBYdM15RJpPiPWnF9Ja3F0JPmDk5B/XpSbOetWcNIq7OovfF2t+JrhrLQbZooDwZe/wCfatbQ/h7bwOt3q8rXd112k5UH+tY1lc+MtOt1itNFiiQDosYH9asjW/Hn/QMH/fA/xpGcZK95pt+mh6KkSRIEjQKo6ADAp9ebHW/Hn/QMH/fA/wAaT+3PHn/QM/8AHB/jTua+3j2f3M9Kpa81Gt+PP+gaP++B/jT4tX8eSyrH/ZyLuONzKMD9aLgq67P7j0eisuxa8tLMyatdxM/U7F2qtcj4j+JNraF7fS0E8w4MpPyj/GhtLcK2Jp0Y3mzvpJ4ovvyIv+8wFYfiTTb/AFixCaZqAh9dp4f8a8L1vWNQ1Pzbi6upXYjgbuB9BTPDfjvWfDkqrHO09rn5oJTkfge1LmTOSjmEayelke0aB4C07SytxdZurvOSXPyg+wrrQoUYUAAdAK5Pwv8AEHR/EkYVZBbXQHMMrAE/Q9660HIyKaO+nycvubHKfEP/AJFOcf7Qq74L/wCRR07/AK5CqXxD/wCRUn/3hV3wX/yKOnf9chR1J/5e/L9TfooopmoUUUUAFFFFABRRRQAUU2SRIo2eRgqKMlicAVyV3rV/4guHsNAzHADtlvyPlH+76mgmUlEu614oW0uBp2mx/bNTfpEvRPdj2pmkeGCl2dU1eT7XqL8jPKReyitDRNAs9EgKwqXnfmSd+Xc+5rVoJUG3eYUUUUGgUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABWBrfjHSdDby55vMn/AOeUYyfx9KzvHfiWTR7JLSzP+mXPAx1Uev1rM8M+AozAL/WwZ7mX5hG5yF+vqaV+xhOpJy5Ke/5DX+KaFz5GlyvH2JNN/wCFpP8A9AiT/vqu5j0ywjQKtlbqo9I1H9KkGnWX/PrB/wB+xRZhyVf5/wADgh8Um76RJ/31S/8AC0j/ANAiX/vqu9/s+y/59YP+/Yo/s+y/59YP+/Yosw9nV/n/AAOC/wCFpH/oES/99Uv/AAtE/wDQHl/Ou8/s+y/59YP+/Yo/s6z/AOfWH/v2KLMPZ1f5/wADgv8AhaJ/6BEv50f8LSP/AECJf++q7z+zrP8A59Yf+/Yo/s2y/wCfWH/v2KLMPZ1f5/wOD/4Wkf8AoES/99UqfFNAwM+lyomeSDXd/wBm2X/PrD/37FMfSrCRCj2duysMEGMUWYclX+f8DN0XxjpGuMIoJ/LnI/1Ugwf/AK9b9ef+JvAEHkNf6KDb3EQ3eUnAbHp6GtHwJ4lfWbFrS7b/AE224Ynqw9frRfuEKklLkqb9PM6+iiimbhRRRQBwdt/yVi4/64f4V3lcHbf8lYuP+uH+Fd5SRlS6+rCiiimahRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRVHV9Rj0nSbi9lICxITz3PagTaSuzhviHr8s9xH4d09iZZSPO2n16LXTeE/D0OgaVHGBmdhulf1Ncf8PdNk1fU7rxDfLuZpCY8+p6mvUBUxb3OHDwdaft5fL0DFFLRTO8O1c34wvpYdMS0tWIubuQQoR2z1P5V0dch4juoIPFGjG5lEcaB3yx4zih7GNeXLA39L02DStPitoFCqq8n+8e5NWpZY4I2lkcKijJJPSsKfxno8YKW85upugjhUsSaoppmq+J5/M1cfZNPU5S1RuX/AN4/0oRPtUvdp6kzeLpbuR10fTJ71FOPN4VD+Jqtd67eiCSPWdBmS1cYZ42DgD1NddBaw20CwwxqiKMAKMAU9kDgqwBB45pilSqSWsjkfBGpIy3OlrOJkgbdC+eTG3I/LpXY1wmmaYmk/EW4it1CxT2/mBfTnn9a7sdaBYXmUOWXQWiiig6jM13SLfWdMltLhQQw+U/3T615/wCDNVuPDXiGbw7qTkRyPiEnoD/9evUiOK89+Jehma3h1m2G2a0ILEenr+FI4sTDkkq8d1+KPQ6KxfCusLrWgW9zuzKF2S/7wrapnXGSlFSXUKKKKCgooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA5D4kf8irJ/vr/OtLwj/yK1h/1zrL+JX/ACKzf9dFrV8If8irYf8AXP8ArS6mS/iv0X6m3S0UUzUaRSYp9ZGs+ItP0OAyXk4ViMqg5ZvoKLomc1BXlsahwBk1y3iDxzpmiK0at59yOkadvqa8/wBf+ImoarvhtP8ARrc5HH3mH1rjiWY5Zix9TWcp22PFxWbJaUjd13xXqmvORPMY4O0KcD8fWsOkFLWbdzwqlWdSXNJ3Ibr/AI9JPpWFW7d/8ekn0rCpo9HAfAxUdo3DoxVgcgg4Ir0Lwr8WNQ0bbbaqjX1qMKGB+dB/WvPKTFWnY9GE5Q+E+nYL/QvHWjyQwz+dE2N6Btroa2dOsIdM0+Gyt93lQqFXccmvlGyvrvTblbmxuHgmXo6HBr1jwl8XhiOz8QLg9BcqP5irTO6nXjJ+9uewUVBaXlvf2yXNrMksLjKupyDU9M6QooooAKKKKACqepanaaTaNc3kojjX8yfQVn654kt9JK20KG6v5P8AV28fJP19KoaZ4auL26XVPETia6zmO3B/dxD6dzQZubvyx3KyW+p+MZfNu/MstF6rB0eYe/oK620tILG2S3toljiQYVVFTgADAGAKKBxglr1CiiigsKKKKACiiigAooooAKKKKACiiigAooooAKKKKACjp1rG1zxRpegQlruceZj5Yl5Y15P4j8f6lre6GBja2p4CIeW+pqXJI5MRjKVD4nr2PRPEHxA0rQyYkJu51+8kRHy/U1H4b+JGi+IWEJc2l0TgRTEDd9DXibHKOTySOTXPchtwJBByDUqZw4fMp1Zu60PpLVvCT6l4utNXMyNbxgB4mzkYzgj1rq8YGK+evCnxN1XQSltd/wCl2Q42sfmUexr2nQPF2keI4VayulMmPmibhl/CrTR6VKcHe2lzD+JN3qVrptutmZEhdv3jxnBB7Co/h/qGp3Oh3f2kvII/9Qz9+K7p0jlQrIoZT2IpqeTEuxAqqOgHSjqV7N+057/I8X0fW9fm8VwBri4eZptskRJwBnkEdq6b4mahqdq1pHbyyRWzKS5Q4y31r0AR2wkMgSMSH+LAzSyLBKmyRUZfQ4NFtDNUJKm4cz16nOeAru+vPDscl87uwYhGbqVrqaiQxRqFTaqjgAU7zE9R+dM3iuWKQ+imeYnqPzo8xPUfnQUPopnmJ6j86PMT1H50AP6jFeX2SDRfitJBCf3dxn5R23DNem+YnqPzrzS+/wCSu2x9dv8A6CaTMK/2X5o9Oooopm4UUUUAcHbf8lYuP+uH+Fd5XB23/JWLj/rh/hXeUkZUuvqwooopmoUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAV558UtRP2S00dOWuXDMAeoB/xr0OvKtcb+2Pira2xUlLfbkfTk0pbHJjpNUbLrod94d01NK0O1tEGNkY3e571rCmqMDGOKcKDohBQiooWiiimWFcfrlvDdeMtHiniWSMxSEqwyK7CuU1jK+NtFPYpItIxr2cdfI6C202yteYLSCI+qRgVaAA6UDpS0zVRS2CkNLSHpQDOXkI/4WLBz/wAuR/8AQq6iuTf5viPFjnbZHPtzXWUGNH7XqLRSCloNwqrqFol7YT20gysiFTVqkPSgmS5k0zzP4eXb6d4h1LQ5jjBLID7f45r02vK9VA0j4q2lwvyicgn8eP8ACvVKmOxy4JtQcH9lhRRRVHYFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFICCMgg/SloA474lf8is3/XRa1fCH/Iq2H/XP+tZXxK/5FZv+ui1q+EP+RVsP+uf9aXUyX8V+i/U3KKKKZqIa8J8ezvN4tuhI7MI8KoJ6CvdjXgfjj/kb77/AHqhnk5w37Bephw2lxcPtggllb0jQtj8qbLDLA+yaKSNv7rqQf1r174X2sK6A8wjXzHkO5iOa2fFPhe11/T2UIqXKDMcmO/v7VNjz45ZKpQVWL17HgwFL3A7mpru1msbuS2uIykqHBBq94agjufE1hFKgZDKMg96zaPMjTftFBmZqFndQWLyS28yIw4ZkIB/Gubr6X8a2sB8FakDEhCQErx0Ir5mBq7WPdjhfq/u3vcdRg9en1qS2RZby3jb7ryqp57E4r6M1Hwjoh8IyWq2EQRINykDkHHXNM3p0nNO3Q+cMU0inL90fSlxQQ9D2r4KXU0mj31s7loopMoCemetep15N8E/+PPUv98V6zWi2PTo/wANBRRUF3eW9hbNcXUqxRKOWY0zUmJCgkkADqTXK6j4iutRu30vw8glmHyy3R/1cX49zVZptT8ZOY7ffZaMDhpDxJN9PQV1OnaZaaVaLbWcKxxqO3U+5oMrup8OiM/Q/DdtpAM0jG5vpOZbmTlifb0FbdFFBooqKsgooooGFFFFABRRRQAUUUUAFFFFABRRRQAUUUEgDJOKACigEEZBzRQBFc3MNnbSXE7hIo13Mx7CvLfEfxNlnDW+jqYk6GZvvH6eldn49JHg2/wew/mK8d8O6BN4i1M2sUixgLuZj2qJNrY8nMMRVjJUqW7MueaW5laWeR5JGOSzsSTUWK6vxF4IvPD8H2jeLiDPLqMFfrXLcVk7nz1alUpztU3EbiJvpWAcV6ZpfgO61bw9Jqa3CICGKIR1A9a80ddkjKeqnBppM9DB0ZwXNJbjaltrm4s7hJ7aeSGVDlXRiCK0vD/h2/8AEt+bSwCF1XczOcBR71X1nR7vQdTksL5QJk5yp4I9RTO9J7no/hT4uSxMtpr6GRD8ouU6j6iuy1fwudf8q/0jVZbdJRuJV2KsD3AB4r52PSvpT4dknwNpmTn91Vo7KMvae5Iwf+Fea1/0MMv/AI9/8VR/wrzWv+hhl/8AHv8A4qvSBS1Vka/Vqfb8X/mebf8ACvNa/wChhl/8e/8AiqP+Fd61/wBDDL/49/8AFV6TRRZB9Wp9vxf+Z5t/wrvWv+hhl/8AHv8A4qj/AIV3rX/Qwy/+Pf8AxVek0UWQfVqfb8X/AJnm3/Cu9a/6GGX/AMe/+Ko/4V3rX/Qwy/8Aj3/xVek0UWQfVqfb8X/mebf8K71r/oYZf/Hv/iqxtM02fSfiPZ2lzcm5kU5Mhzk/KfUmvYq8wvf+SvQfh/6CaTRlVowhytd11Z6fRRRVHYFFFFAHB23/ACVi4/64f4V3lcHbf8lYuP8Arh/hXeUkZUuvqxqyIwJV1O3rg9KTzYzH5gkXZ/e3cfnXlTajJ4auPGdkZD8wE1vk9C/y8fiayobu6sPh1f8Ah66kc3a3S2+QTkiQ560zU9sVgyhlIIPQg0yWeGAKZpY4wxwC7AZPpzXDXHiyfRriHw7o2mPf3Vnbr55LhVTjpk96xfGHiWPXvB+malbW8nmR6givBn5g4PK0Aer0Vxmi+MryfXo9G1fSJLCaaPfAxcMHA/rWv4q8Rp4Z0f7a0DzuziOONeMsemaANyiuS0TxdeXc1xFq2kS2PlReaJQweNlxnqO9Yy/E2fMd8+iSpo0k3lLdFxu643bfSgD0aiuJ/wCE11C48V3Oi2Gjm4WAoWn3gAIe5p48eCKw1+W7tPKn0mTZ5YbPmA4wR9c0AdnRXE33jm6t49NtbbS2uNUvIfOMIcBY19yap3PxLa38OzXx0xhe210ttPalxwSeoNAHoVFZWgahqGpWDXGo6ebGQv8AJEWDHbgYJ961aACiiigAooooAKKKKACvKvD3+mfE+/nbkxs+P5V6rXlXg07PiFqinqd/86mRxYz4qa8z1McgGlpF+6M0tM7ELRRRTGFct4wVrc6fqicm0nBYf7J4NdRVe9s4r+zltpQCkilTxQZ1Y80WkSwyCWJJFOVYAg1JXJeHtRk024bQ9SbbLEcW7sf9anbHvXWA8UBSnzx8xaRjgc0ZrnfEurtCq6ZYEyajdDair/AD1Y+mKCpyUVdlXQh/aHijVdTH+qUi2jI77ev611lZ2iaWmkaZFaryyjLt/eY9T+daVBFGLUddxBS0gpaDUKQ9KWg9KAPLfiQnk6/pN10wf5EV6fC26CNvVQf0rzL4pqWutLVTgksAfxFdHB4W1M28Z/4Se+GVBxtHHFSt2efh5NVqiS7HW0Vyv/CKan/0NN//AN8Cl/4RXU/+hov/APvkVR280ux1NFct/wAIrqf/AENF/wD98ij/AIRXU/8AoaL/AP75FA+Z9jqaK5b/AIRXU/8AoaL/AP75FJ/wimp/9DTf/wDfAoDmfY6qiuV/4RTVP+hpv/8Avgf40f8ACKap/wBDTf8A/fA/xoDmfY6qiuV/4RTVP+hpv/8Avgf40f8ACKap/wBDTf8A/fA/xoDmfY6qiuV/4RTVP+hpv/8Avgf40f8ACKap/wBDTf8A/fA/xoDmfY6qiuV/4RTVP+hpv/8Avgf40f8ACKap/wBDTf8A/fA/xoDmfY6qiuV/4RTVP+hpv/8Avgf40f8ACKap/wBDTf8A/fA/xoDmfY6qiuV/4RTVP+hpv/8Avgf40f8ACKap/wBDTf8A/fApC5n2Oqo6iuV/4RTVP+hpv/8Avgf40o8K6p/0NN//AN8D/Gi7DmfYqyyz+DtYaR2eTRbtsknkwOf6V2KOssaujBlYZBHcV514o0i5sdP8iXxDe3c1wdkVqUB3n/Cuu8LaZc6RoFvaXcxlmUZOTnbnt+FBlTlLncLaGP8AEr/kVm/66LWr4Q/5FWw/65/1rK+JX/IrN/10WtXwh/yKth/1z/rR1LX8V+i/U3KKKKZqB6V4F44/5G++/wB6vfe1eBeOP+Ruvv8AeqZbHkZx/BXqejfDL/kWf+2hral8RW9t4kGkXBVGkjDRse59KxPhl/yLP/bQ1yXxNZ08VRvG5R1hUhh1HWpjsVGu6GChNHW+O/CK6xZm9s0/02JeAP4x6GvNvCcbp4tsUkXYyy4KntXpfgjxaus2i2d04F5GMHJ++PWm6v4R/wCKnstZsk6SDz0H/oVJq5jWw8cQ44il80a/jUf8UXqvP/Lu38q+fvD/AIM1rxJG8un22YUbaZHbaM+1fQPjQbvB2pr6wMP0rzbwF8QNO8OaJ/ZmoxSL5bFlkjXOQfWrdrnZXlB1VGbsZFr8KPE8d7byPDAESVWJ83sDXud3byS6TLbJjzGhKDPrjFcnF8V/Dc0qRLLNudgozGeprspbhIbVrls7FTefpSOmlCEU+VngC/CbxWFG6C349Ja5/XvDWreG50j1K28sPnYwOQ3417P/AMLd8M5/1k//AH7Nef8AxF8c2XitbWCwiYQwMWaSQYJJ7AUjmqQpcraZ1HwT/wCPPUv98V6xXiHwr0i71K2vWt9WuLEIwyIlB3fWu8vfBurTxMIvFF4GPZlGD+Rq1sb0pSVNWibWseJbDSE2PJ5t03EdvHyzn0rHs9BvvEF0mpeIjiIHdDYL91PdvU1xx8Oar4c1L7RqFzcLAePt1uvmFfc55Fdpa6Bd3lsk9v4svJI2GQyhTn9aCITnUfvxt5HWqqooVQAoGAB2pa5b/hFtT/6Gi+/74H+NL/wi2p/9DPff98D/ABpnRzS7HUUVy3/CLan/ANDRff8AfA/xo/4RXVP+hovv++B/jQPmfY6miuW/4RXVP+hovv8Avgf40f8ACK6p/wBDRff98D/GgOZ9jqaK5b/hFdU/6Gi+/wC+B/jR/wAIrqn/AENF9/3wP8aA5n2Oporlv+EV1T/oaL7/AL4H+NH/AAiuqf8AQ0X3/fA/xoDmfY6miuW/4RXVP+hovv8Avgf40f8ACK6p/wBDRff98D/GgOZ9jqaK5b/hFdU/6Gi+/wC+B/jR/wAIrqn/AENF9/3wP8aA5n2Oporlv+EV1T/oaL7/AL4H+NH/AAiup/8AQ0X3/fA/xoDmfY6morm3S7tpLeTOyRSpwfWub/4RXVP+hovv++B/jR/wiuqf9DRff98D/GgTk+xBo9/P4d1EaDqkhaFzmzuW/iH90n1rsK8u8RaPdTaha6RDrV1f3rMHKsgxEP7xI6V6VZwvbWUMMkpleNArOerEd6DOjKV3FrRGD4/48GX/ANF/mK8/+FvPiC4P/TD+td/4/wD+RLv/AKL/ADFcB8K/+Q/cf9cP61Etzz8X/vlM9OuLixvLmXSLhlMjx5MbfxKeK8a8W+GJfDupMEUmzlJMTentW98RL6407xfaXVs5SSOEEEfU11um3mn+OfDrwXCr5m3Ei55RvUUkk9DOuoYqcqT0ktg8G/8AJP4/+ub/ANa8Eh0bU9UuJ2sbKa4CyMGMa5A5r6L0fS5NH8LtYysC0auAR6c4rzDwh48tfCdldafc2bygzs6vHjJye9Ox1SioxhCo7aF74S6Dqmma1fS31jNbo0AClx1Oazvid4e1fUPF7XFlp888JiUbkXjNeh+FPHlj4qvZ7W2tpYXiTed+ORnFV/E/xGsPDOqmwuLSaVwobKYxzSNuSCp2voeB3+mX2mOI721lgdhkCRcZr6I+HX/Ii6X/ANcq8h8f+NYfFv2X7NZvDHBnLPjLE1678Oif+EF0zj/llVImhZVGkdYKWkFLVHaFFFFABRRRQAUUUUAFeYXn/JXoPw/9BNen15he/wDJXoPqP/QTSZhX2j6o9Pooopm4UUUUAcHbf8lYuP8Arh/hXeVwdt/yVi4/64f4V3lJGVLr6s848YeDr7V/HGmX1tFmzYKt2wIHCtuGabrfgu/u/iRY6jbof7MLJJccjG5OBxXpNFM1PKvFPgi/Piu61a2086lb3YBaJZzE0bAY7dRxRd+DtWh8HWdvp+lxRXi3y3LwCYsBg9ya9VooA8+07TfEet+MbPVdZ0+Kwt9PjKxqsm4yMe/0roPGVjqN/ovladbWt0wcGS3uRlZF9PY10NFAHmHhvwrrL3t959kdJ02e3MX2UTmQFiPvD0rCtPh/qsDJYT6Alwqy4+1G7YIUz12564r2yigDjvDmiXun+NNavJbcpaTRxpC+7O7AFZHivwZqGpeMraeyX/iW3mz+0MED7hJH9K9IooA818c+C7y91u21Wxs/tsSwiGS2ExiIA6EEVlTeB9T/AOEUljtdGW2upryKQwicudqnqSe9ev0UANQERqD1Ap1FFABRRRQAUUUUAFFFFABXlWmEad8XLmEnCy7iB9RXqteWeOgdH8dabqwACOFDN9DikzjxqajGa6M9SoqOCRZYI3U5DKCDUlB1p3QtFIaQuFzu4AHWmMWisG88X6TaSNCsxnnHWKFS5/TiqLeI9YvgU0zQ5lB6S3BCqPwzmgxdaC03ZX8Y2UWoa3o1tJld8jEMhwwwK7C2i8i3ji3s+xcbmOSa4S1S803xZBceIZFkNwu23lUfJGx6rXfgjAoIoe9KUrWEYZUjOM1xOk6ZFp3jy7jEryM9uH3SNk5J7V25PFcPr4l1bxPbwaNJ5d9bKTNcDog/un1zQwxCWj3aO2FOrkv7a1/Tfk1DSDcKOs1qwOfwPNXLbxlpMsixTySWkrdEuEK/r0pFRxEHo9PU6EUtMjlSVAyMGU9CDT6ZugoPSikJ4NAHmHj5jeeL9JsUOSGUkfVhXpyLtjVfQAV5ZZbtd+K0knWG2JI+i8fzNeq1Me5x4TVzn3YUUUVR2BRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFB6cUUUAc7pXh+ZdXn1fVZFnvGJWFV+7EnbHvXRUUUExio7HHfEr/kVm/wCui1q+EP8AkVbD/rn/AFrK+JX/ACKzf9dFrV8If8irYf8AXP8ArS6kL+K/RfqblFHauMvbTx219O1pfWS25kJiDAZC54/hplTnyrZv0Oz7V4F44/5G++/3q9e8PQ+I4mn/ALent5VIHlmLt654FeP+OePF99/vVEnoeVmz5sOnbqej/DEg+GsZ58w5rj/igyjxQnP/ACwXP61z2jeLdR8PK62kqmNuqMM8+tZGqavd6xfPd3cheV+p9KlSVrHDPExnhFR6k9nqk2nXcdzauVmjOVNe5eEfE0HiTS1mU7bhOJY/Q+v0r54yau6XrF9ot2LmxnaKTofQ/WkpWFgsQ8O/I+gPGWB4R1LJx+4b+VfNvWur1fx7rWt2RtLqWNYWGHES4LfXmuWxTbNMZiI1ppxJLCINqdqfSZD/AOPCvpm/cf8ACPz9h9nPJ/3a+Y0LI4dTgg5FdJc+OdeudJ/s17oeQV2sQvzEemaEy8Li1STU+pxYOQD7UtTtbKPucY7dqiZWXqKZcasZaxPZfgn/AMeWpH/bFesV5N8ESfsOpZ/56D+Ves1a2PYoO9NDZI0ljaORQyMMFSMg1x93omoeHLp9Q8PkyWzHM1i5yD6lfQ12VFMuUFIy9F16z1y28y3YrIvDwvwyH3Falc5rXhgXVwNR0yT7JqadJF6P7MO9N0XxO00/9m6zCLPUk4wfuy+6mglTadpnS0UUUGgUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAVDdeebWUWxUTlTsLdM9qmooAw/Dug/wBkwvPdSfaNQnO6aY9/Ye1blFFAopRVkcz4/wD+RLv/AKL/ADFeafD3VLTSdcd7uQRpJGVDHoD716r4wsp9Q8LXtvbIXlZMqo6nBzXzncSSwzNE6MjKcFWGCKiR4uYucK8KkVsdj8RNZs9T19ZLSUSJHEELD1yawND8R3mhanHd27nYOJI+zj0rGzmlNT5nnOpKVR1Op723j/QLjQnuftqqzRn90fvZx0xXg07iSaRx0ZiRTMUUczNcRipVrX6HafDTWbDRdcuHvZPKE0QRXPTOc1k/ETU7bWPFk1zZt5kIRUDeuKwwaQqMdKV2OGLnGCg9igelfSnw8H/FC6X/ANcq+eEspLuZYYI2eRzgKoySa+kfBdhPpfhLT7O5XbNHENy+lXE9TA1PaSbN4UtFFWekFFFFABRRRQAUUUUAFeYXv/JXoPqP/QTXp9eYXv8AyV6D6j/0E0mYV9o+qPT6KKKZuFFFFAHB23/JWLj/AK4f4V3lcHbf8lYuP+uH+Fd5SRlS6+rPMlvPFOt+LNcsrHXYrOGycCNHhB6j1rU8J+MpZdL1Q+ILiEPpk5hkuUACyY7iuZh8KJ4h8YeLN811BMjDyWicoCSvf1rKmtJ5/h0NPtLFo7zS70fbUCZL4P38fxUzU9T0vxroesicWdyzPChkZGQhio7gd6kbxfoyaCmsm4P2N3Eatt53E4xj61554VSXVvGljeHVPtRghYMqWRiUL/dJ9ajs9Iux41Xwo0L/ANnQXp1AP2K9QPzoA9D1fxtoeiSxxXtyyyOobYqFioPcjtRf+NtB060s7q4vB5F2CYXUZBxXmeux6ho/jjWJJ7wWUN4o8uV7QzCRcfdBHSnWOl+QvhGFy9xC17JIvmQlcKfY+9AHo13480CxsLa7nuXVLld0S7DvI9cVetvE+j3WiNq8d7H9iUHdITjbjsfeuK8e/Y7TxHZXTm7sJo4SsV7FCJIsf3WXBrAuodW1r4dXEkWnohivxIWig2faIx/Hs/pQB6ZonjLRPEFy9tYXRaZRu2OpUkeo9aua5r+n+HbNbvUpjFCzhA2M8mvMPCqy6v4u0y6OqfaHtUYFY7Fogox0JNdD8XJFi8OWcjqWRb2IsoGSRn0oA6HRvGuh69eSWljdFp0G7YylSw9RnrUdl460HUL82VvdM06sysNhwu3rk9q42O9tvEnxB0W50W2lSGygf7VKYSg5AwpyPrS+GtLmvPBfieK1i2Xk1xMqNtwx5PegDrbX4g+G7zUlsYb8GVm2KxXCMfQNWg/ifSotTudPlnMdxbxec4cYGz1B715PcX9jqfgnTfDdhpk660jxqU8ggxMDyxOMVofEC0n1u+s9N0+2aa906033cq5AZcDKZ7k4oA9BsvGWj39xZwwyyB7wMYN6YD464q7Ya7YalqN5Y2sjPNZkCb5eAT71wHiSW3vPAWleI9Jh8qXSmV1jIxsA4ZTXQ/Diwkt/DZvrhcXOoTNcyZ7Bug/KgDsKKKKACiiigArj/iNo/wDaXhxp4x++tW8wEDnHeuwpksSzQvE4yrgqQfSgipBTg4vqcv4C1ldV8OwqzAy248pufTpXVV5Lp0j+B/G81nMSLK5bCHtgng16xG4dAwOQe4pHPhavNHkluhxOASe1cbcz3fivUZLO0maDS4G2zTIeZWHVRW34mlu4dAumsomknK7UCjJGe9c9pGtDSNMhtE0W/JQfMwj+83c9fWgdadpKL2OmsNG0/TYhHa20aY6nbyfxq9gDpXM/8Jef+gLqH/fsf40v/CXt/wBAbUP+/Y/xp37lqpSjsbGr6XDq+nyWsw6jKN3RuxFZXhzVZ/Mk0fUift1t0J/5aJ2YU3/hL2/6Auof9+x/jWDrupz38sF7Y6Tfw39u2UcpgMO6nnpS5kY1a0YvnizqvEestp1qkFsu++uTshT39foKf4f0YaRY4kPmXUp3zynqzGuP0zUrv+1ptV1XSb2S6PyQqiZWNPb3rof+Etb/AKA+of8Afsf40BCrGT55fI6bFVr3TbLUITFdW0cqn+8tYH/CXSf9AfUP+/Ypw8XSf9AfUP8Av2KLo29rTe5RlhuvBl4s0Ukk2jSth0Y58j3+ldjDMs0SyIwZWAIIPUVyl94jF7ZS20uiX7RyqVIMY7/jVvwSbv8AsMQ3cMsRhconmDkr2/SmRTnapyx2Z0uax/EurR6RoN1dM2GCEJ7k9K1iQBzXlvjK+l8SeJrbQLFt0cb4kI6bu/5UPQeJqOEPd3ehqfC/TZBZ3Wrz8yXT4RiOo7n8/wCVeg1V06yi03T4LOEYSJAoq1SSsjSjTVOmoIKKKKZqFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAHHfEr/kVm/66LWr4Q/5FWw/65/1rK+JX/IrN/10WtXwh/yKth/1z/rS6mS/iv0X6m5RRXGX1h48kvpns9XsYrcufLQqMhc8dYz29zTKnPlWzfodka8d+JHhfUE1OXVbaFpbZxmQoMlD/hXUf2Z8Rf8AoOWH/fC//G66HRIdcS3ePXZbWdhjY8P8XrkYA/Kptc5qsFiI8kk0fNrZ/iyD70yvdvEvw30zWd9xaKLW7PO5fut9RXkeveF9S8P3Bju4SY8/LKoyp/GocbHi1sHOlutDFpDS0UrHJYSiiikAUtFGCTgAknoBTSGJT4bSe9mWC2heWVjhVRcmux8NfDjVNaMc9z/otoTnc4+Zh7CvYNB8KaT4ehC2duPMI+aV+WP41SR6GFwNSfvPRGJ8NPC1z4c0WVr1dlxcvuMfdR2rt6KK0PehFRiooKKKKCgrN1jQ7PW7byrlMOvMcq8Mh9Qa0qKBNJqzOMt9Y1DwvcLZa6WnsD8sWoAdPZ/SuwiljniWWJ1dGGVZTkGm3FtDdwNBcRrJG4wysMg1yMlhqXhGZrjTN93pROZLQnLR+6+3tQZ6w80dnRVHStXs9ZtBcWcu5ejKfvKfQir1BommroKKKKBhRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABXOeI/BOkeI4m86FYbjHyzxrhh9fWujooJlCM1aSufPPiTwBq/h3dL5bXVoP+W0ak4HuO1ct0ODX1cyq6lWUMp4IIrhPE3wx03Vw9xp+LO6PPH3GP07VDieViMtV+al9x4ZRWtrXhzU/D05iv7dlGflkHKn8aXQ/Dep+IZ/LsICy5+aRhhV/Gp5Ty/YT5+RLUyem3g5PQAV1fh/wBrGussrIbW1P/AC1kXqPYV6N4c+GumaM0c18y3V4RxuPyg+w713KRIigKMADAApqJ6eHy7W9U57w/4M0vw/Ept4Ve4H3pnGWP+FdEM0tLVpHq06caa5Y7AKWkFLTLCiiigAooooAKKKKACvML3/kr0H1H/oJr0+vML3/krsH1H/oJpMwr7R9Uen0UUUzcKKKKAODtv+SsXH/XD/Cu8rg7b/krFx/1w/wrvKSMqXX1Y1Y0VmZUUM3UgcmkEMSliI0Bb7xCjn60+imajI4Yos+XEiZ67VApfLTzPM2Lvxjdjn86dRQAySGKXHmRo+Om5QaDFGSpMaHb935Rx9KfRQAySKOUYkjVx6MM0oRVTYqgL0wBxTqKAGRwxREmOJEJ67VArE8U+Gx4lsre2NwYBDcJNkLnO09K3qKAI4oIoVwkaKSOSqgZpyRpGCERVycnaMZp1FAEYghWTzBEgc/xBRn86URRq7OI1DN94gcmn0UAc14l8KN4hjgtV1CSzsQ26eCFBib2NdFDClvBHDEoWONQqgdgKfRQAUUUUAFFFFABRRRQBzHjXw2Nf0kmIYvIAWiPr7Vi+A/FRcf2HqR8u8gG1N/VgO31r0GuA8b+DpLmX+2tIzHex/M6xjBfHce9I469OUZ+2p79fNHe5Bo2iuI8IeN4tTC2GokQ3yfKNxx5n/167gEYzmmb0qkasbobtFG0U7NLQaWQzbRtp9FILIZto2+1PooCyGbR6UbR6U6imFkNKjHSjPpTjXJ+K/GVroNs0URWW8bhUB+77mhuxlUqQpq8mReOPFi6NaGztiGvZhhQBnaPWovh94ZfTbM6neqftlyMgN1Vf8ayvCHhO51W9/4SDXt7s53RxSDr6E+1emdBgVKu9WYUacqk/bVPkgoooqjtCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA474lf8is3/XRa1fCH/Iq2H/XP+tZXxK/5FZv+ui1q+EP+RVsP+uf9aXUyX8V+i/U3KMikPQ1xl3o3jSS9ne216COBpGMaFPurngfd9KZU5uOyudnketGR61w39h+Ov+hit/8Avj/7Gk/sPx1/0MUH/fH/ANjSuZ+2l/I/w/zO6yPWoLm1t7yJobiJJUYcqwzXGf2H46/6GKD/AL4/+xrU0DTfEtpftJq+rRXUGwgRquOeOfuigFUcnZxf4HKeJfhTFLvuNFfy3PPkueD9D2ryvUNPvNLuWt723eGRTjDDr9K+pqyNc0fStYhFtqMMT7+E3Abs+xpNHJiMvhL3oaM+Z80V6RrPwjv4bgtpU6zQt0SThl/Gtnw38Kba1K3GssLiQc+SB8o+vrU8h5ywFVys0edaF4T1bxDKFs4CIs/NM/Cgf1r17w18PNM0LbNMn2q7xku/Kg+wrqoorXTrbaixwQoO2AAK5DXfiFBCzWmjxfbLgnG9eVH+NNJI9KlhKVBc09WbPizV5dE0Ga5tWjWfgJuGcfhVvwzfT6l4dsru5YNNJGCxAxk1xNn4Q1jxLMt34guJYowciPuR9O1ei2VnDp9nFa267Yol2qKpHZBycrvRE9FFFM1CiiigAooooAKKKKAOW1bwzNDdnVdAkFtfZy8R/wBXN7EevvVvRPEsWoyNZ3cZtdRj4kgfv7j1Fb1Y+ueHbXWowxJgu05iuY+HQ/WgzcHF3j9xsUVyNl4hu9GvI9L8QrtzxFffwSfX0NdarK6hlIKkZBHegqMlIWiiigoKKKKACiiigAooooAKKKKACiiigAooooAKKKKAIri2guojHcQpKh/hdQRRBbw2sQjgiSJB/CigCpaKAPNPGN1eaH40sdVd3e0OMLngdiK9DtbqO7to54XDxyLuVh3FVNd0S217TXs7gYzyj45Q+orzu3m8SeA5XheBrrTw2QeSv1HpS2ZztulNt/C/wPVqK4FPinp+395Yzo/cZBp3/C09M/59Lj8xRdFfWKX8yO8FLXBf8LT0z/n0uPzFH/C09L/59Lj8xRdB9YpfzI72iuC/4Wnpf/PpcfmKP+Fp6X/z6XH5ii6D6xS/mR3tFcF/wtPS/wDn0uPzFH/C09L/AOfS4/MUXQfWKX8yO9orgv8Ahael/wDPpcfmKZN8VLEJ+5sJ3fsCQBRdB9YpfzI7q6uobO2knncJGi5JJrzXwmreIfHd3rLKfJiJKHtk8D9KgnuPEPj6ZII7drSwB+Zudv4nv9K9E0PRbbQdNSzth05Zz1Y+tG5KftZJpe6vxZp0UUUzoCiiigDg7b/krFx/1w/wrvK4O2/5Kxcf9cP8K7ykjKl19WFFFFM1CiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA4vxX4Dh1cte6cVtr8c5HAc+/oawNK8Z6l4dmXTfEUMjIh2iXHzAf1Fep1R1PSLHV7cwXtusikYyRyPoaRyVMN73tKT5ZfgxmnatZapCstpcJIpHQHkfhV+vNr34cXum3BuPD96y85Ebtgj8aqJ4t8V6G/k6rpzSoONxU/+hDg0ELFVKelaPzWx6tRXn1r8UtNIAuraeFu/GRWonxF8OsoJu2Gexjb/ChM1WMov7R1tFcofiJ4cAz9tP4Rt/hVC5+KOjpkW0c85A4whH86LoJYuildyO5qteX9tYQma5mSNB3Y4rzaTxx4j1h/K0nTCit0bYW/+sKktPAOt6xMJ9fvmRDyUV9zf4Ci/Yy+tSqO1KLfn0JNb+INxfznTfDsLvI52+dtyfwH9TVzw14BKTLqWvN9ouydwjJyFPqfU11ej+HtN0OHZZW4VscyNyx/GtSi3cuGGblz1Xd/ghAAAABgDoKWiimdYUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBx3xK/5FY/8AXVa1PB//ACKth/1z/rWV8S8/8IseP+Wq1B4a8W6LY+HrO3uLwJKiYZdp4pdTC6VZ37L9TuO1LXNnx14e/wCf4f8AfJpf+E58P/8AP+P++TTua88e50dFc5/wnPh//n/H/fJo/wCE58P/APP+P++TQHNHudHRXOf8Jz4f/wCf8f8AfJo/4Tnw/wD8/wCP++TQHNHudHXBfE2WSC10+WJ2R1lJBU8jpW1/wnPh/wD5/wAf98muN+IHiLTNXtLSOyuPNZHLMApHpSexlXnFU3qel6e5fT7dmJLGMEk/SsLX/G2maMHiEgnuQOI0559zXHrrniHxPFHp+kQNBbqoVpM4/Wuk0D4e2OnMlzfsbu7Bz833Qf60ege0lP8Ahr5/1uc8lv4m8cTK0rG00706DHt612uheEdL0JAYohJP3mfk/wD1q3lUIoVQAB0ApaLFQpKLu9WFFFFM1CiiigAooooAKKKKACiiigAooooArX1hbajbNb3cKyxsMEMK5P8A4mvg2U5L32iE/WSAf1FdrSMoZSrAEHgg0EShfVaMr2GoWup2iXVpKssTjIIqzXI6h4fvdIupNU8OEB25ms2PySD29DWtofiK11qMoN0N2nEtvIMMp/qKBRm78stGbFFFFBoFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABTXRZFKuoZT1BFOooAoPomlyNufT7Yn18sU3+wNI/wCgdbf9+xWjRQKyM7+wNI/6B1t/37FH9gaT/wBA62/79itGigOVGd/YGk/9A62/79ij+wNI/wCgdbf9+xWjRQHKuxnf2BpH/QOtv+/Yo/sDSP8AoHW3/fsVo0UByrsZ39gaR/0Drb/v2KcmiaXGcpp9sD6+WKv0UBZDURY1CooVR0AFOoooGFFFFABRRRQBwdt/yVi4/wCuH+Fd5XB23/JWLj/rh/hXeUkZUuvqwooopmoUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAU1kVxh1DD0Ip1FAGTdeGdEvCTNplszHq3lgGs6TwB4ckxmwC4/usRXT0UGcqVOW8Ucwnw/wDDaf8ALjn/AHnJq9a+FNCszmHTLcN6lATWzRRYI0acdooZHFHEoWNFRR0CjFPoooNAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAKmo6ba6rZta3kQkhbqKwv+Fe+HP+fNv+/jV1FVb3UrPThGby5jgEjBE3tjcfSgmUIy+JXMH/hXvhz/AJ82/wC/jUf8K98Of8+bf9/G/wAa6C8vrXT7Vrq7nSGBcZdzgDNULPxToWoXAt7TVbWaZuiJICTSsifY0/5V9xnf8K98Of8APm3/AH8b/Gj/AIV74c/582/7+N/jW8NRs21A2AuIzdhN5i3fMF9cVaosg9jT/lX3HL/8K98Of8+bf9/Go/4V74c/582/7+N/jXUUUWQexp/yr7jl/wDhXvhz/nzb/v41A+H3h0MCLM8HPMhrpt679m4buuM806iyD2NP+VfcQWtpb2UCw20KRRr0VBgVPRRTNAooooAKKKKACiiigAoooyB3oAKKKKACiiigAooooAKKKKACsLW/DcWpSC8tZDaajGP3dxHwfofUVu0UClFSVmctpXiSa3uV0zX4xbXmdscx4Sb3HvXU9RkVQ1XR7LWbQ295EHX+FuhU+oPrXMx3+peD5BBqZe70nO2O6HLR/wC97UGd3D4tjtaKit7iG7gSeCRZInGVZTkGpaDUKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA4O2/5Kxcf9cP8K7yuDtv+SsXH/XD/Cu8pIypdfVhRRRTNQooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAryLx0qeKfFVxp4u0hj0m1MikvtzOcED8q9cfdsbb97HGfWuE0f4cWTm8uvEUMV7fXM7SFxnCqegoAyfEesrrnwZN6cFx5aSgf3lYA1ia3deG9U0XT7TQLBzrO+PY8MDIVPGSTXRv8ADzUYdC1rRbS4hWyup0ltFOf3eCCQfyrvrCwis7SCPyohIiBSyqOSBQBwukrKvxdkWc5mGlKH+uRmtzxj4ivtIawsNKhjk1C/l8uLzfuqO5NOh8OXUfxCm18yR/ZpLTyAn8Wcg1n/ABHtYvsun6kL9bG7tJwYJnQsmfRsdqAK2l+JfE0Xi6bR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263TMSFg+6F7fjWpQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAGVregWWu23l3CbZV5jmThkPqDWFaa1qPhu5XT/EDedatxDfqOPo3vXZVDdWsF7bPb3EayROMMrDrQRKPWO5JHIksayRsGRhkMDwRTq4x7TUvB8hlsA95o/V7c8vCP9n2rptL1az1i0W5sphIh6jup9CKAjO7s9GXaKzL7WorDVbGxljb/SyQr9gQOladBVwooooGFFFFABRXP674x0jQRtuJ983/ADyj5NM8O+N9F8SgraXOycdYZRtb/wCvRchVIOXLfUh8beJj4f01Vt8G7nO1P9ketc74d8CHU1XVNdleR5vmERPJ+v8AhXQa74Q/tjxJY6iZQYYuJomPpyMV0wAGABwOlK2pn7Nzm3PZbL9TKj8LaJFGI106DA6ZWn/8I1o//QPt/wDviue+IWt6hpNnbLZMYxKx3ygcjHQUngPW9S1HR7x7wtKYf9XIw5bjpRfWw/aQ9p7O2p0X/COaOP8AmHW//fFH/CO6P/0Drf8A74ry/TvGWut4ki8+ZyrzBHgxwATjH4V0fxD1/U9LltILORoEkUszjqT6UXRCxFNwc7aI64eHdHP/ADDrf/vil/4RvR/+gdb/APfFZngXVLzVdAWa9yZFcqHIxvHrXUUzaPLKKkluZX/CN6P/ANA63/74o/4RvR/+gdb/APfFatFBXKuxlf8ACN6P/wBA63/74pkvhbRZoyj6dBtPouK2KKA5V2PNPEHgWXSt2qaDLIjxHeYgeQPb/Cuj8FeJf7e00pcH/TYOJBjGfQ10zgMpBGcjFeXaSh0L4oSWkQxFOWAHsRn+dLY53FUppx2eh6nRRRTOkKKKKAODtv8AkrFx/wBcP8K7yuDtv+SsXH/XD/Cu8pIypdfVhRRRTNQooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAPSvN9O8PeMdC1HVH0w6e0F5ctOPNJyM16RRQBwN34b8StqVr4htJrOPWBCYbmIgmNx2xTIvAeo3Oi60dQv0/tXVR87xr8iAdF+leg0UAeW2ng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iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA//2Q==


[image_ref_aeqqm09i]: data:image/jpeg;base64,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
