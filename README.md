# Proyecto de Infraestructura como Código con Terraform

Este proyecto implementa una infraestructura completa en AWS utilizando Terraform como herramienta de IaC, con pipelines automatizados en GitHub Actions y una aplicación web moderna con ORM.

## 🏗️ Arquitectura

### Componentes de Infraestructura

1. **Red (VPC)**
   - VPC en región us-east-1 (Virginia)
   - 2 Subnets (Pública y Privada)
   - Route Tables configuradas
   - Internet Gateway para acceso a internet
   - Security Groups para DB y Web

2. **Base de Datos MySQL**
   - RDS MySQL 8.0 en subnet privada
   - Base de datos "sportsstore" con inicialización automática
   - Acceso privado desde EC2
   - **ORM SQLAlchemy** para gestión automática de esquemas

3. **Servidor Web (EC2)**
   - Instancia EC2 en subnet pública
   - Aplicación web Flask con SQLAlchemy
   - Interfaz web moderna con Bootstrap
   - Funcionalidades CRUD completas para inventario
   - Inicialización automática de datos de ejemplo

## 🚀 Pipelines de GitHub Actions

### 1. Pipeline de Infraestructura (`terraform-apply.yml`)
- Crea toda la infraestructura AWS
- Configuración simplificada sin dependencias externas
- Expone outputs para otros workflows

### 2. Pipeline de Aplicación (`app-deploy.yml`)
- Despliega la aplicación Flask en la EC2
- Configura variables de entorno
- Instala dependencias Python
- **Inicializa automáticamente la base de datos con datos de ejemplo**
- Verifica el despliegue

### 3. Pipeline de Destrucción (`terraform-destroy.yml`)
- Destruye toda la infraestructura
- Limpia recursos AWS
- Verifica la destrucción

## 🛠️ Configuración

### Secrets de GitHub Requeridos

```bash
AWS_ACCESS_KEY_ID=tu_access_key
AWS_SECRET_ACCESS_KEY=tu_secret_key
AWS_DEFAULT_REGION=us-east-1
DB_USERNAME=admin
DB_PASSWORD=MySecurePassword123
SSH_PRIVATE_KEY=tu_clave_privada_ssh
```

### Variables de Terraform

```bash
# variables.tfvars
aws_region = "us-east-1"
db_username = "admin"
db_password = "MySecurePassword123"
key_name = "tu-key-pair"
```

## 📁 Estructura del Proyecto

```
terraform-project/
├── .github/workflows/
│   ├── terraform-apply.yml
│   ├── app-deploy.yml
│   └── terraform-destroy.yml
├── modules/
│   ├── networking/
│   ├── database/
│   └── compute/
├── app/
│   ├── app.py              # Aplicación Flask con SQLAlchemy
│   ├── requirements.txt    # Dependencias Python
│   └── templates/
│       └── index.html      # Interfaz web moderna
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## 🗄️ Base de Datos con ORM

### Ventajas de SQLAlchemy

✅ **Inicialización Automática**: Las tablas se crean automáticamente
✅ **Migraciones**: Gestión de esquemas sin scripts SQL manuales
✅ **Validación**: Validación automática de datos
✅ **Seguridad**: Prevención de SQL injection
✅ **Mantenibilidad**: Código más limpio y mantenible

### Modelo de Datos

```python
class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    price = db.Column(db.Float, nullable=False)
    stock_quantity = db.Column(db.Integer, default=0)
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
```

## 🌐 Interfaz Web

### Características

- **Diseño Responsivo**: Bootstrap 5 para dispositivos móviles
- **Gestión CRUD**: Agregar, editar, eliminar productos
- **Indicadores Visuales**: Colores para niveles de stock
- **Validación**: Validación en frontend y backend
- **Datos de Ejemplo**: Inicialización automática con productos deportivos

### Endpoints API

- `GET /api/products` - Listar productos
- `POST /api/products` - Agregar producto
- `PUT /api/products/{id}` - Actualizar producto
- `DELETE /api/products/{id}` - Eliminar producto
- `GET /api/products/{id}` - Obtener producto específico
- `POST /api/init-db` - Inicializar base de datos

## 🤖 Uso de ChatGPT

### Para Desarrollo y Debugging

1. **Análisis de Errores**: Usar ChatGPT para analizar errores de Terraform y GitHub Actions
2. **Optimización de Código**: Solicitar mejoras en la configuración de Terraform
3. **Troubleshooting**: Resolver problemas de conectividad y configuración
4. **Documentación**: Generar documentación técnica y guías de usuario
5. **ORM Optimization**: Mejorar modelos y consultas SQLAlchemy

### Prompts Útiles para ChatGPT

```
"Analiza este error de Terraform y sugiere una solución: [error]"
"Optimiza esta configuración de security group para MySQL"
"Mejora este modelo SQLAlchemy para incluir validaciones"
"Revisa este pipeline de GitHub Actions y sugiere mejoras"
"Genera un endpoint API para búsqueda de productos"
```

## 🚀 Despliegue

### Opción 1: Pipeline Automático
1. Push a la rama `main`
2. Los pipelines se ejecutan automáticamente
3. La base de datos se inicializa automáticamente
4. Monitorear en GitHub Actions

### Opción 2: Manual
```bash
# Aplicar infraestructura
terraform init
terraform plan
terraform apply

# Desplegar aplicación
cd app
pip install -r requirements.txt
python app.py

# Inicializar base de datos (opcional)
curl -X POST http://localhost:5000/api/init-db
```

## 🔧 Troubleshooting

### Error: "Database connection failed"
- **Causa**: Security groups o configuración de red
- **Solución**: Verificar configuración de networking

### Error: "Table doesn't exist"
- **Causa**: Base de datos no inicializada
- **Solución**: Llamar endpoint `/api/init-db`

### Error: "Permission denied"
- **Causa**: SSH key configuration
- **Solución**: Verificar secrets de GitHub

## 📊 Monitoreo

- **AWS Console**: Monitorear recursos en tiempo real
- **GitHub Actions**: Ver logs de pipelines
- **Application Logs**: Revisar logs de la aplicación en EC2
- **Database Logs**: Monitorear RDS en AWS Console

## 🧹 Limpieza

Para destruir toda la infraestructura:
1. Ejecutar pipeline de destrucción
2. O manualmente: `terraform destroy`

## 📝 Notas Importantes

- **ORM Advantage**: No se requieren scripts SQL manuales
- **Auto-initialization**: La base de datos se inicializa automáticamente
- **Modern UI**: Interfaz web moderna y responsiva
- **API First**: Diseño API-first con documentación clara
- **Security**: Base de datos en subnet privada
- **Scalability**: Arquitectura preparada para escalar

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles. 