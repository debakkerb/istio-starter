# Istio Starter

The purpose of this repository is to give you an example of a simple application, where multiple pods are talking to each other through a service mesh. This is not an exhaustive Istio tutorial, as this would take us too far.  However, it should show you how Istio can be configured on a GKE cluster and how you can control traffic between pods.  

This is not a production ready configuration for Istio and should not be treated as such.  If teams want to run Istio on a production environment, it is recommended to tighten the security controls in this demo.

I deliberately do not use any Terraform modules.  The reason is that I want to make clear what configuration is being applied where and why.  Terraform modules tend to hide these implementation details.  Given that this is a demo, it's my opinion that people shouldn't have to click through multiple layers to learn what is going on where.  However, in a production environment I do encourage team to identify and create a modular set up of their Terraform codebase.

This is also the reason why I don't use the excellent [https://github.com/GoogleCloudPlatform/bank-of-anthos](Bank of Anthos demo), as this is a full blown microservices application.  I wanted to keep this demo as simple as possible, so we can focus on Istio without having to investigate why some application components are failing.

**This tutorial was created for Istio vXXX and GKE vXXX.**

## Concepts

I do recommend to read the official documentation if you want to have more detailed information on Istio and the different resources it uses to control the service mesh.

### Virtual Service


### Gateways
### DestinationRules

## Application structure

## Prerequisites

## Run the demo