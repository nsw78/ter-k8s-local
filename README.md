![Bunker Mode Enabled](https://img.shields.io/badge/Bunker--Mode-ON-black?style=for-the-badge&logo=kubernetes)

---

## 🧠 Visual do Bunker DevOps

> *Porque todo projeto épico merece um centro de comando visual.*

![Cyberpunk Bunker](IMAGEM_DO_BUNKER_AQUI)

---

```markdown
# 🧪 Projeto Local Kubernetes com API Python (FastAPI)

> *Direto do bunker: monitoramento em tempo real, deploys explosivos e uma API que responde antes da sua mãe mandar você desligar o computador.* 🚨👨‍💻

Este repositório é um laboratório completo para testar e validar uma **API em FastAPI** com um ambiente local em **Docker Desktop + Kubernetes**, infra como código via **Terraform**, e observabilidade usando **Prometheus + Grafana**. Tudo automatizado com um `Makefile` que beira a magia negra.

---

## ✅ Pré-requisitos

Antes de abrir o portal da automação, tenha:

- 🐳 **Docker Desktop** com Kubernetes ativado
- ⚙️ **kubectl** para domar os pods
- 🟣 **Terraform** (infra estrutura sob controle)
- 🐍 **Python 3.12** (só se quiser rodar sem container)
- 🧠 **Make** — o botão de autodestruição (ou implantação) do projeto

---

## 🚀 Como usar

### 1. Build da imagem Docker

```bash
make build
```

### 2. Push para o Docker Hub

```bash
make push
```

> 📦 Imagem definida por `IMAGE_NAME=nswit/client-api` lá no `Makefile`

### 3. Subir a API no Kubernetes

```bash
make api-up
```

Isso irá:

- Criar o namespace `local-api` (caso não exista)
- Aplicar os manifests do diretório `kubernetes/local-api/`

### 4. (Opcional) Provisionar Infraestrutura com Terraform

```bash
make apply
```

### 5. (Opcional) Derrubar tudo e fingir que nada aconteceu

```bash
make destroy
```

---

## 🎯 Observabilidade com Prometheus + Grafana

### Subir o stack de monitoramento

```bash
make monitoring-up
```

- Namespace `monitoring`
- Deploy Prometheus e Grafana
- ConfigMaps: `prometheus.yml` e fonte de dados Grafana

### Ver logs e métricas como um hacker em filme

```bash
make logs-api           # Logs da API
make logs-monitoring    # Logs Prometheus + Grafana
make debug-api          # Testa /metrics via curl interno
```

---

## 🧹 Comandos de manutenção Kubernetes

```bash
kubectl get pods -n local-api
kubectl logs -l app=client-api -n local-api
kubectl rollout restart deployment/client-api -n local-api
```

---

## 📜 Resumo dos comandos mágicos

| Comando               | Descrição                                               |
|----------------------|----------------------------------------------------------|
| `make build`         | Builda a imagem Docker                                   |
| `make push`          | Envia a imagem para o Docker Hub                         |
| `make api-up`        | Sobe a API no Kubernetes                                 |
| `make api-down`      | Remove a API e seu namespace                             |
| `make monitoring-up` | Sobe Prometheus + Grafana + ConfigMap                    |
| `make monitoring-down`| Remove monitoramento por completo                      |
| `make apply`         | Aplica Terraform                                         |
| `make destroy`       | Destrói a infra provisionada                             |
| `make all`           | Executa build + push + deploy da API + monitoring        |
| `make reset`         | Remove tudo — do cluster à alma do projeto               |

---

## 🛠️ Rodar API local sem Kubernetes

```bash
cd api/app
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

> Só pra lembrar: você está fora do cluster, então sem Prometheus olhando 👀

---

## 😎 Frase motivacional do bunker

> _"Se nada quebrar no deploy, você fez errado. A verdadeira magia está nos logs."_ — Alguém sob pressão num cluster de produção
```

---

