resource "kubernetes_namespace" "web_app_namespace" {
  metadata {
    name = "app3"
  }
}

resource "kubernetes_manifest" "web-app" {
  manifest = yamldecode(file("../k8s/app.deployment.yaml"))
}

resource "kubernetes_manifest" "web-app-service" {
  manifest = yamldecode(file("../k8s/app.service.yaml"))
}

resource "kubernetes_manifest" "web-app-ingress" {
  manifest = yamldecode(file("../k8s/ingress.yaml"))
}