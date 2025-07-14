#############################################
# Variáveis Globais
#############################################

# Nome completo da imagem Docker (incluindo namespace Docker Hub)
IMAGE_NAME=nswit/client-api

# Namespace do Kubernetes para isolar a aplicação
NAMESPACE=local-api

#############################################
# Alvos principais para Build, Push e Deploy
#############################################

# Constrói a imagem Docker localmente
build:
	cd api/app && docker build -t $(IMAGE_NAME):latest .

# Realiza o push da imagem para o Docker Hub
push:
	docker push $(IMAGE_NAME):latest

# Cria namespace (caso não exista) e aplica os manifests no Kubernetes
api-up:
	- kubectl create namespace $(NAMESPACE) || echo "Namespace já existe"
	kubectl apply -f kubernetes/ -n $(NAMESPACE)

# Remove os manifests aplicados no Kubernetes
api-down:
	- kubectl delete -f kubernetes/ -n $(NAMESPACE) || echo "Manifestos já removidos ou não existem"

# Aplica a infraestrutura via Terraform
apply:
	cd terraform && terraform init && terraform apply -auto-approve

# Destroi a infraestrutura via Terraform
destroy:
	cd terraform && terraform destroy -auto-approve

# Executa pipeline completa: builda, faz push da imagem e aplica no Kubernetes
all: build push api-up

#############################################
# 📚 Instruções rápidas:
#
# make build     → builda a imagem local
# make push      → envia a imagem para Docker Hub
# make api-up    → cria namespace (se necessário) e aplica manifests
# make api-down  → remove deployment e serviço no Kubernetes
# make apply     → cria infraestrutura via Terraform
# make destroy   → destrói a infraestrutura via Terraform
# make all       → builda imagem, faz push e aplica no Kubernetes
#############################################
