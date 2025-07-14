FROM python:3.12-slim

WORKDIR /app

# Instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Validação de pacote opcional
RUN pip show email_validator || echo "📦 Atenção: email_validator não está instalado!"

# Copia o restante do projeto
COPY . .

# Executa a aplicação
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]