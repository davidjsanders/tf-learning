# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Submodule:      dev
# Code set:       main.tf
# Purpose:        Deploy the ScaleWeb example to a dev environment.
#                 The dev environment is scaled to specific resources
#                 and sizes required for devs and cannot be exceeded
#                 (e.g. by specifying larger machine sizes or counts)
# Created on:     17 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Configure the K8S provider
provider "kubernetes" { }

resource "kubernetes_pod" "test" {
  metadata {
    name = "terraform-example"
    labels {
      app = "MyApp"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"
    }
  }
}

resource "kubernetes_service" "test" {
  metadata {
    name = "terraform-example"
  }
  spec {
    selector {
      app = "${kubernetes_pod.test.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = "${kubernetes_service.test.load_balancer_ingress.0.hostname}"
}