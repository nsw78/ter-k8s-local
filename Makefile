#############################################
# 📦 Variáveis Globais
#############################################

IMAGE_NAME = nswit/client-api
VERSION = latest
NAMESPACE_API = local-api
NAMESPACE_MONITORING = monitoring

#############################################
# 🔨 BUILD & PUBLISH
#############################################

build:
	@echo "🔨 Buildando imagem Docker: $(IMAGE_NAME):$(VERSION)"
	cd api/app && docker build -t $(IMAGE_NAME):$(VERSION) .

push:
	@echo "🚀 Enviando imagem Docker para o Docker Hub"
	docker push $(IMAGE_NAME):$(VERSION)

#############################################
# 🚀 API: Deploy & Cleanup
#############################################

api-up:
	@echo "📦 Criando namespace da API se necessário..."
	- kubectl get namespace $(NAMESPACE_API) >/dev/null 2>&1 || kubectl create namespace $(NAMESPACE_API)
	@echo "📦 Aplicando manifests da API"
	kubectl apply -f kubernetes/local-api/ -n $(NAMESPACE_API)

api-down:
	@echo "🧹 Removendo recursos da API"
	- kubectl delete -f kubernetes/local-api/ -n $(NAMESPACE_API) || echo "✅ API já removida."
	- kubectl delete namespace $(NAMESPACE_API) || echo "✅ Namespace da API já removido."

logs-api:
	@echo "📜 Logs da client-api"
	kubectl logs -l app=client-api -n $(NAMESPACE_API) --tail=50 -f

#############################################
# 📊 MONITORAMENTO: Deploy & Configs
#############################################

monitoring-up:
	@echo "📊 Criando namespace do Monitoring se necessário..."
	- kubectl get namespace $(NAMESPACE_MONITORING) >/dev/null 2>&1 || kubectl create namespace $(NAMESPACE_MONITORING)
	@echo "🧠 Aplicando ConfigMap Prometheus (prometheus-config.yaml)..."
	kubectl apply -f kubernetes/monitoring/prometheus-config.yaml -n $(NAMESPACE_MONITORING)
	@echo "🧠 Aplicando ConfigMap Grafana (datasource)..."
	kubectl apply -f kubernetes/monitoring/grafana-datasource.yaml -n $(NAMESPACE_MONITORING)
	@echo "📊 Aplicando deployments e services: Grafana + Prometheus"
	kubectl apply -f kubernetes/monitoring/ -n $(NAMESPACE_MONITORING)

monitoring-down:
	@echo "🧹 Removendo recursos de Monitoramento"
	- kubectl delete -f kubernetes/monitoring/ -n $(NAMESPACE_MONITORING) || echo "✅ Monitoring já removido."
	- kubectl delete namespace $(NAMESPACE_MONITORING) || echo "✅ Namespace do Monitoring já removido."

monitoring-restart:
	@echo "🔁 Reiniciando Grafana e Prometheus"
	kubectl rollout restart deployment/grafana -n $(NAMESPACE_MONITORING)
	kubectl rollout restart deployment/prometheus -n $(NAMESPACE_MONITORING)

#############################################
# 🌍 TERRAFORM: Infraestrutura
#############################################

apply:
	@echo "🌍 Inicializando e aplicando infraestrutura via Terraform"
	cd terraform && terraform init && terraform apply -auto-approve

plan:
	@echo "🔍 Exibindo plano de execução do Terraform"
	cd terraform && terraform init && terraform plan

destroy:
	@echo "🔥 Destruindo infraestrutura via Terraform"
	cd terraform && terraform destroy -auto-approve

#############################################
# 🎁 PIPELINE COMPLETA
#############################################

all: build push api-up monitoring-up
	@echo "✅ Tudo pronto! Infra, API e monitoramento no ar."

reset: api-down monitoring-down destroy
	@echo "🧨 Projeto totalmente limpo!"

#############################################
# 🧪 TROUBLESHOOTING & DEBUG
#############################################

status-api:
	@echo "🔍 Status do Deployment da API"
	kubectl rollout status deployment/client-api -n $(NAMESPACE_API)

status-monitoring:
	@echo "🔍 Status do Grafana e Prometheus"
	kubectl rollout status deployment/grafana -n $(NAMESPACE_MONITORING)
	kubectl rollout status deployment/prometheus -n $(NAMESPACE_MONITORING)

describe-api:
	@echo "🧬 Detalhes do Pod da API"
	kubectl describe pod -l app=client-api -n $(NAMESPACE_API)

describe-grafana:
	@echo "🧬 Detalhes do Pod do Grafana"
	kubectl describe pod -l app=grafana -n $(NAMESPACE_MONITORING)

describe-prometheus:
	@echo "🧬 Detalhes do Pod do Prometheus"
	kubectl describe pod -l app=prometheus -n $(NAMESPACE_MONITORING)

logs-monitoring:
	@echo "📜 Logs do Grafana"
	kubectl logs -l app=grafana -n $(NAMESPACE_MONITORING) --tail=50
	@echo "📜 Logs do Prometheus"
	kubectl logs -l app=prometheus -n $(NAMESPACE_MONITORING) --tail=50

debug-api:
	@echo "🧪 Validando conectividade com /metrics"
	kubectl run debug-pod --rm -i --tty --image=curlimages/curl --restart=Never -- \
	curl client-api.local-api.svc.cluster.local:8000/metrics

check-deps:
	@echo "📦 Dependências no container:"
	docker run --rm $(IMAGE_NAME):latest pip list

#############################################
# 📝 Ajuda Rápida: Targets disponíveis
#############################################
# make build → Builda imagem Docker
# make push → Envia imagem para Docker Hub
# make api-up → Deploy da API
# make api-down → Remove a API
# make logs-api → Ver logs da API em tempo real
# make monitoring-up → Deploy Prometheus + Grafana + ConfigMaps
# make monitoring-down → Remove tudo de monitoramento
# make monitoring-restart → Reinicia Pods sem apagar recursos
# make apply → Aplica infraestrutura via Terraform
# make plan → Exibe plano de execução Terraform
# make destroy → Remove infraestrutura provisionada
# make all → Executa pipeline completa
# make reset → Remove tudo e limpa projeto
#############################################

---

.PHONY: build push api-up api-down logs-api monitoring-up monitoring-down monitoring-restart apply plan destroy all reset