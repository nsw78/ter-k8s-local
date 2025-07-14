resource "kubernetes_namespace" "local_api" {
  metadata {
    name = "local-api"
  }
}

resource "kubernetes_namespace" "teste" {
  metadata {
    name = "ns-teste"
  }
}
