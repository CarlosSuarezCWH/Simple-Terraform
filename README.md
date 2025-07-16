# Sports Store Infrastructure with Terraform

Este proyecto crea una infraestructura completa en AWS para una tienda de deportes con una aplicación web Flask y base de datos MySQL.

## Arquitectura

- **VPC** en us-east-1 con subnets pública y privada
- **RDS MySQL** en subnet privada
- **EC2** con aplicación Flask en subnet pública
- **Security Groups** configurados para acceso seguro
- **Pipelines CI/CD** con GitHub Actions

## Pre-requisitos

1. **AWS CLI** configurado con credenciales
2. **Terraform** instalado (versión >= 1.0)
3. **Llave SSH** subida a AWS EC2 Key Pairs con nombre `Keys_par_2`
4. **Repositorio en GitHub** para los pipelines

## Configuración

1. **Edita `terraform.tfvars`**:
   ```hcl
   db_password = "TuContraseñaSegura123!"
   aws_region = "us-east-1"
   key_name = "Keys_par_2"
   ```

2. **Configura GitHub Secrets** (para CI/CD):
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_DEFAULT_REGION`

## Deploy

### Opción 1: Manual
```bash
terraform init
terraform plan
terraform apply
```

### Opción 2: GitHub Actions
1. Haz push a la rama `main`
2. O ejecuta manualmente el workflow "Terraform Apply"

## Acceso a la Aplicación

Después del deploy, obtén la IP pública de la EC2 desde los outputs:
```bash
terraform output application_url
```

O desde la consola de AWS EC2.

## API Endpoints

- `GET /products` - Listar productos
- `POST /products` - Agregar producto
- `PUT /products/{id}` - Actualizar producto
- `DELETE /products/{id}` - Eliminar producto

## Destruir Infraestructura

```bash
terraform destroy
```

O ejecuta el workflow "Terraform Destroy" en GitHub Actions.

## Estructura del Proyecto

```
.
├── app/                    # Aplicación Flask
├── modules/               # Módulos Terraform
│   ├── compute/          # EC2 y recursos de cómputo
│   ├── database/         # RDS MySQL
│   └── networking/       # VPC, subnets, security groups
├── scripts/              # Scripts de inicialización
└── .github/workflows/    # Pipelines CI/CD
``` 