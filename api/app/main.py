from fastapi import FastAPI, Form, Request, status
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, EmailStr
from typing import List

app = FastAPI()

# Configura o diretório de templates e estáticos
templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")

# Modelos
class ClientBase(BaseModel):
    name: str
    email: EmailStr

class Client(ClientBase):
    id: int

clients: List[Client] = []
next_id = 1

@app.get("/", response_class=HTMLResponse)
async def form_page(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.post("/create-client", response_class=HTMLResponse)
async def create_client(
    request: Request,
    name: str = Form(...),
    email: str = Form(...)
):
    global next_id
    # Simples verificação de email duplicado
    if any(c.email == email for c in clients):
        return templates.TemplateResponse("index.html", {
            "request": request,
            "error": "E-mail já cadastrado!"
        })
    new_client = Client(id=next_id, name=name, email=email)
    clients.append(new_client)
    next_id += 1
    return RedirectResponse(url="/clients", status_code=status.HTTP_303_SEE_OTHER)

@app.get("/clients", response_class=HTMLResponse)
async def list_clients(request: Request):
    return templates.TemplateResponse("clients.html", {"request": request, "clients": clients})
