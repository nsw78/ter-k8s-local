Aqui está seu `README.md` com uma estrutura profissional, clareza, formatação melhorada e explicações práticas:

````markdown
# 📦 Projeto Local Kubernetes com API Python (FastAPI)

Este projeto é uma estrutura simples e funcional para rodar uma API Python utilizando **FastAPI**, **Docker**, **Kubernetes** local via **Docker Desktop**, além de **Terraform** para provisionamento de infraestrutura.

---

## ✅ Pré-requisitos

Antes de começar, tenha instalado:

- 🐳 **Docker Desktop** com Kubernetes ativado
- 🟣 **Terraform** (caso queira aplicar infraestrutura)
- ⚙️ **kubectl** (ferramenta de linha de comando para Kubernetes)
- 🐍 **Python 3.12** (caso queira rodar a API localmente sem container)

---

## 🚀 Como usar

### 1. Buildar a API e gerar a imagem Docker

```bash
make build
````

### 2. Enviar imagem para o Docker Hub

```bash
make push
```

> 📌 **Dica**: O nome da imagem é definido no `Makefile` pela variável `IMAGE_NAME=nswit/client-api`.

### 3. Subir a API no Kubernetes

```bash
make api-up
```

Isso irá:

* Criar o namespace `local-api` (caso ainda não exista)
* Aplicar os manifests do diretório `kubernetes/` para rodar a API.

### 4. (Opcional) Aplicar Infraestrutura com Terraform

```bash
make apply
```

### 5. (Opcional) Derrubar infraestrutura via Terraform

```bash
make destroy
```

---

## 🧹 Comandos úteis no Kubernetes

### Atualizar a imagem sem derrubar tudo:

```bash
kubectl set image deployment/client-api client-api=nswit/client-api:latest -n local-api
kubectl rollout status deployment/client-api -n local-api
```

### Verificar pods rodando:

```bash
kubectl get pods -n local-api
```

### Verificar logs da API:

```bash
kubectl logs -l app=client-api -n local-api
```

---

## 🎁 Resumo rápido dos `make` comandos

| Comando         | Ação                                                                 |
| --------------- | -------------------------------------------------------------------- |
| `make build`    | Builda a imagem localmente                                           |
| `make push`     | Envia a imagem para o Docker Hub                                     |
| `make api-up`   | Aplica os manifests no Kubernetes (namespace + deployment + service) |
| `make api-down` | Remove o deployment e serviço do Kubernetes                          |
| `make apply`    | Sobe infraestrutura usando Terraform                                 |
| `make destroy`  | Destroi infraestrutura via Terraform                                 |
| `make all`      | Builda, faz push e sobe a API no Kubernetes                          |

---

## 📢 Observação importante

Para rodar localmente sem Kubernetes:

```bash
cd api/app
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```


