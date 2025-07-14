## Variáveis
IMAGE_NAME=client-api
NAMESPACE=local-api

.PHONY: build apply destroy api-up api-down

build:
	cd api && docker build -t $(IMAGE_NAME):latest .

api-up:
	kubectl create namespace $(NAMESPACE) || true
	kubectl apply -f kubernetes/

api-down:
	kubectl delete -f kubernetes/ || true

apply:
	cd terraform && terraform init && terraform apply -auto-approve

destroy:
	cd terraform && terraform destroy -auto-approve
