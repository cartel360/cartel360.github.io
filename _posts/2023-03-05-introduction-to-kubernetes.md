---
layout: post
title: Introduction to Kubernetes
date: 2023-03-06 00:00:00 
description: Kubernetes is an open-source platform for automating deployment, scaling, and operations of application containers across clusters of hosts, providing container-centric infrastructure.
image:
  path: /assets/img/kubernetes.png # 
tags: [Productivity, Kubernetes, DevOps] # add tag
categories: [DevOps]
published: true
---
Kubernetes is an open-source platform for automating deployment, scaling, and operations of application containers across clusters of hosts, providing container-centric infrastructure.

## kubernetes Architecture
At the core of Kubernetes is the concept of a cluster, which is a set of nodes (virtual or physical machines) that run containerized applications. Each node in the cluster runs a container runtime (such as Docker) and a set of Kubernetes components that provide cluster-wide services such as networking, storage, and security. The Kubernetes components include the Kubernetes API server, the etcd database, the kubelet, and the kube-proxy.

The Kubernetes API server is the central control plane of the cluster and exposes the Kubernetes API, which is used by clients to interact with the cluster. The etcd database is a distributed key-value store that stores the cluster state, configuration, and metadata. The kubelet is a component that runs on each node and is responsible for managing the containers on that node. The kube-proxy is a network proxy that runs on each node and handles network routing and load balancing.

## Kubernetes Concepts
Kubernetes provides several high-level abstractions that allow developers to define and manage their applications in a declarative way. Some of the key concepts in Kubernetes include:

- Pods: A pod is the smallest deployable unit in Kubernetes and represents a single instance of an application. It can contain one or more containers that share the same network namespace and can communicate with each other through localhost.

- Services: A service is an abstraction that represents a set of pods and provides a stable endpoint for accessing them. It can load balance traffic across the pods and provide automatic failover and resiliency.

- Deployments: A deployment is a higher-level abstraction that manages a set of replicas of a pod or a set of pods. It allows developers to declaratively manage the desired state of their application and provides features such as rolling updates and rollbacks.

- ConfigMaps and Secrets: ConfigMaps and Secrets are Kubernetes resources that allow developers to store configuration data and sensitive information such as passwords and API keys separately from the application code.

- StatefulSets: A StatefulSet is a higher-level abstraction that manages a set of stateful pods, such as databases or other stateful applications.

## Why Use Kubernetes
With kubernetes, you can schedule and run your applications on clusters of either virtual or physical machines, it also allows one to move from a **host-centric** infrastructure to a **container-centric** infrastructure which provides full advantages of containers.

With kubernetes, you can achieve some common needs of applications running in production which are:
- Scalability: Kubernetes allows applications to scale up or down dynamically based on demand. It can automatically create or terminate new instances of application containers to ensure that the application can handle increased traffic.

- High Availability: Kubernetes ensures that the application is highly available by automatically restarting containers if they fail or become unresponsive. It also provides features like load balancing, rolling updates, and automatic failover to ensure that the application is always available to users.

- Resource Management: Kubernetes helps manage and optimize resource utilization by allocating resources such as CPU and memory to different containers based on their requirements. It can also limit resource usage to prevent any single container from consuming too many resources.

- Service Discovery and Load Balancing: Kubernetes provides built-in service discovery and load balancing capabilities that make it easy for applications to communicate with each other. This ensures that traffic is evenly distributed across all instances of an application and that requests are routed to healthy containers.

- Configuration Management: Kubernetes allows you to store and manage configuration data separately from the application code, making it easier to update and manage application configurations across different environments.

- Rollout and Rollback: Kubernetes makes it easy to roll out new versions of an application and rollback to previous versions if necessary. This allows for seamless updates and reduces the risk of downtime or errors during the deployment process.

Overall, Kubernetes provides a robust platform for managing containerized applications in production environments, with features that ensure high availability, scalability, and efficient resource management.


## Kubectl
Kubectl is a command-line interface (CLI) tool that is used to interact with Kubernetes clusters. It allows users to manage and control their Kubernetes clusters by issuing commands to the Kubernetes API server. Kubectl is an essential tool for developers, system administrators, and DevOps engineers who work with Kubernetes clusters.

### Installing Kubectl
Kubectl can be installed on a variety of operating systems, including Windows, macOS, and Linux. The installation process varies depending on the operating system being used. 

1. On macOS, you can install Kubectl using the Homebrew package manager:
```bash
brew install kubectl
```

2. On Linux, you can download the Kubectl binary and install it using the following commands:
```bash 
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

3. On windows, we can install using Chocolatey:
```bash
choco install kubernetes-cli
```


### Usage 
Once installed, Kubectl can be used to manage and control Kubernetes clusters. The basic syntax for Kubectl commands is:
```bash
kubectl [command] [TYPE] [NAME] [flags]
```

For example, to get a list of all the pods in a Kubernetes cluster, you can use the following command:
```bash 
kubectl get pods
```

This will display a list of all the pods in the default namespace. You can use the `-n` flag to specify a different namespace:
```bash
kubectl get pods -n <namespace>
```
To get more information about a specific pod, you can use the `describe` command:
```bash
kubectl describe pod <pod-name>
```
This will display detailed information about the pod, including its status, IP address, and container information.

### Creating Resources
Kubectl can also be used to create resources in a Kubernetes cluster. For example, to create a deployment, you can use the following command:
```bash
kubectl create deployment <deployment-name> --image=<image-name>
```
This will create a new deployment with the specified name and image. You can use the `kubectl apply` command to apply a configuration file that defines multiple resources:
```bash
kubectl apply -f <config-file.yaml>
```
This will create or update the resources defined in the configuration file.

### Updating Resources
Kubectl can be used to update existing resources in a Kubernetes cluster. For example, to update a deployment, you can use the following command:
```bash
kubectl set image deployment/<deployment-name> <container-name>=<new-image-name>
```
This will update the specified container in the deployment to use the new image.

### Deleting Resources
Kubectl can be used to delete resources in a Kubernetes cluster. For example, to delete a deployment, you can use the following command:
```bash
kubectl delete deployment <deployment-name>
```
This will delete the specified deployment and all of its associated resources.

## Minikube
Minikube is a lightweight, open-source tool that allows you to run a single-node Kubernetes cluster on your local machine. It provides an easy and convenient way to get started with Kubernetes development and testing without the need for a full-scale Kubernetes deployment.

Minikube runs a virtual machine on your local system and installs a small, self-contained Kubernetes cluster within it. It can be used to experiment with different Kubernetes features, test application deployments, and try out different configurations without affecting a production environment.

Minikube is also designed to work with popular container runtime such as Docker, enabling you to quickly build and deploy containerized applications on the local Kubernetes cluster. This allows developers to test their applications locally before deploying them to a larger Kubernetes cluster or a production environment.

Minikube provides several features that make it an ideal tool for local Kubernetes development and testing:

- Single-Node Cluster: Minikube runs a single-node Kubernetes cluster on the local machine, which makes it easy to develop, test, and deploy applications without the need for a production environment.

- Multiple Hypervisors Support: Minikube supports multiple hypervisors, including VirtualBox, Hyper-V, and KVM, making it easy to run on a variety of operating systems.

- Lightweight: Minikube is lightweight and easy to install, with a small footprint that doesn't consume many system resources.

- Easy to Use: Minikube provides a simple and intuitive command-line interface that allows users to start and stop the cluster, manage the Kubernetes dashboard, and deploy applications.

You can read more about Minikube here [here](https://kubernetes.io/docs/tutorials/hello-minikube/)

### Installing Minikube
Minikube is a single binary. Thus, installation is as easy as downloading the binary and placing it

1. Installing Minikube on macOS using Homebrew:
```bash 
brew install minikube
```

2. Installing Minikube on Linux using apt-get:
```bash 
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

3. Installing Minikube on Windows using Chocolatey:
```
choco install minikube
```
Note that these commands assume that you already have a hypervisor installed on your system. If you don't have a hypervisor installed, you'll need to install one separately before installing Minikube. Also, keep in mind that these commands may change over time, so it's always a good idea to check the Minikube documentation for the latest installation instructions.

### Usage 
To start a new cluster:
```bash 
minikube start
```

This will create a new cluster of local virtual machines with Kubernetes already installed and configured.

You can access the Kubernetes dashboard with:
```bash 
minikube dashboard
```

### Creating Resources
Minikube can also be used to create resources in the Kubernetes cluster. For example, to create a deployment, you can use the following command:
```bash 
kubectl create deployment <deployment-name> --image=<image-name>
```
This will create a new deployment with the specified name and image.

### Updating Resources
Minikube can be used to update existing resources in the Kubernetes cluster. For example, to update a deployment, you can use the following command:
```bash
kubectl set image deployment/<deployment-name> <container-name>=<new-image-name>
```
This will update the specified container in the deployment to use the new image.

### Deleting Resources
Minikube can be used to delete resources in the Kubernetes cluster. For example, to delete a deployment, you can use the following command:
```bash
kubectl delete deployment <deployment-name>
```
This will delete the specified deployment and all of its associated resources.

Minikube creates a related context for `kubectl` which can be used with:
```bash
kubectl config use-context minikube
```

Once ready the local Kubernetes can be used:
```bash
kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
kubectl expose deployment hello-minikube --type=NodePort
curl $(minikube service hello-minikube --url)
```

To stop the local cluster:
```bash
minikube stop
```
To delete the local cluster, note new IP will be allocated after creation:
```bash
minikube delete
```

## Kubernetes API
Kubernetes provides a powerful REST API that allows users to interact with a Kubernetes cluster programmatically. This API is the foundation upon which many Kubernetes tools, such as kubectl, are built. In this article, we'll take a look at how to call the Kubernetes API using HTTP requests.

The Kubernetes API is organized into several groups of resources, each of which is represented by a set of HTTP endpoints. For example, the "pods" resource group contains endpoints for listing, creating, updating, and deleting pods.

To call the Kubernetes API, we'll need to construct an HTTP request with the appropriate method (GET, POST, PUT, DELETE, etc.), endpoint, headers, and payload (if any).

Let's take a look at an example. Suppose we want to get a list of all the pods in a Kubernetes cluster. We can do this by sending an HTTP GET request to the "/api/v1/pods" endpoint of the Kubernetes API. Here's what the request might look like:
```bash
GET /api/v1/pods HTTP/1.1
Host: my-kubernetes-cluster
Authorization: Bearer <token>
```
In this example, "my-kubernetes-cluster" is the hostname of the Kubernetes API server, and "`<token>`" is a valid authentication token that allows us to access the API. The token can be obtained using kubectl or other authentication methods, such as OAuth2 or client certificates.

When we send this request to the Kubernetes API, we'll receive an HTTP response containing a JSON object that represents the list of pods. We can then parse this JSON object and use it to perform further operations, such as updating or deleting specific pods.

Calling the Kubernetes API directly can be a powerful way to automate operations on a Kubernetes cluster, but it requires some knowledge of the API's resources, endpoints, and authentication methods. Fortunately, there are many libraries and tools available that make it easier to interact with the Kubernetes API from various programming languages, such as Python, Java, Go, and JavaScript. These libraries and tools abstract away many of the low-level details of the API and provide higher-level abstractions for common Kubernetes operations.





