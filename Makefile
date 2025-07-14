#############################################
# 📦 Variáveis Globais
#############################################

# Nome completo da imagem Docker (Docker Hub namespace incluso)
IMAGE_NAME=nswit/client-api

# Namespace Kubernetes da aplicação
NAMESPACE=local-api

#############################################
# 🚀 Comandos Principais: Build, Push, Deploy
#############################################

# 🔨 Constrói a imagem Docker localmente
build:
	@echo "🔨 Buildando imagem Docker: $(IMAGE_NAME):latest"
	cd api/app && docker build -t $(IMAGE_NAME):latest .

# 🚀 Faz o push da imagem para o Docker Hub
push:
	@echo "🚀 Enviando imagem para o Docker Hub..."
	docker push $(IMAGE_NAME):latest

# 📦 Cria namespace (se não existir) e aplica os manifests Kubernetes
api-up:
	@echo "📦 Criando namespace (se necessário)..."
	- kubectl get namespace $(NAMESPACE) >/dev/null 2>&1 || kubectl create namespace $(NAMESPACE)
	@echo "🚀 Aplicando manifests Kubernetes..."
	kubectl apply -f kubernetes/ -n $(NAMESPACE)

# 🧹 Remove os recursos do Kubernetes (ignora erros se já removidos)
api-down:
	@echo "🧹 Removendo recursos Kubernetes..."
	- kubectl delete -f kubernetes/ -n $(NAMESPACE) || echo "📝 Recursos já removidos ou inexistentes."

# 🌍 Aplica infraestrutura usando Terraform
apply:
	@echo "🌍 Aplicando infraestrutura com Terraform..."
	cd terraform && terraform init && terraform apply -auto-approve

# 🔥 Destroi infraestrutura via Terraform
destroy:
	@echo "🔥 Destruindo infraestrutura via Terraform..."
	cd terraform && terraform destroy -auto-approve

# 🎁 Pipeline completa: Build + Push + Deploy
all: build push api-up
	@echo "✅ Pipeline concluída com sucesso!"

#############################################
# 📝 Resumo Rápido:
#
# make build     → Builda imagem local
# make push      → Faz push da imagem para Docker Hub
# make api-up    → Cria namespace e aplica manifestos Kubernetes
# make api-down  → Remove deployment/serviço no Kubernetes
# make apply     → Aplica infraestrutura via Terraform
# make destroy   → Destroi infraestrutura via Terraform
# make all       → Executa build + push + deploy
#############################################
