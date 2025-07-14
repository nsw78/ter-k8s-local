output "namespace_local_api" {
  value = kubernetes_namespace.local_api.metadata[0].name
}

output "namespace_teste" {
  value = kubernetes_namespace.teste.metadata[0].name
}
