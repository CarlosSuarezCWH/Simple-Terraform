import os
from flask import Flask, request, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from datetime import datetime
from dotenv import load_dotenv
load_dotenv()

app = Flask(__name__)

# Configuración de la base de datos
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{os.environ['DB_USER']}:{os.environ['DB_PASSWORD']}@{os.environ['DB_HOST']}/{os.environ['DB_NAME']}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)

# Modelo de Producto
class Product(db.Model):
    __tablename__ = 'products'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    price = db.Column(db.Float, nullable=False)
    stock_quantity = db.Column(db.Integer, default=0)
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'category': self.category,
            'price': self.price,
            'stock_quantity': self.stock_quantity,
            'description': self.description,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }

# Rutas API
@app.route('/api/products', methods=['GET'])
def get_products():
    products = Product.query.all()
    return jsonify([product.to_dict() for product in products])

@app.route('/api/products', methods=['POST'])
def add_product():
    data = request.json
    try:
        product = Product(
            name=data['name'],
            category=data['category'],
            price=float(data['price']),
            stock_quantity=int(data['stock_quantity']),
            description=data.get('description', '')
        )
        db.session.add(product)
        db.session.commit()
        return jsonify(product.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400

@app.route('/api/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    product = Product.query.get_or_404(product_id)
    data = request.json
    
    try:
        product.name = data.get('name', product.name)
        product.category = data.get('category', product.category)
        product.price = float(data.get('price', product.price))
        product.stock_quantity = int(data.get('stock_quantity', product.stock_quantity))
        product.description = data.get('description', product.description)
        
        db.session.commit()
        return jsonify(product.to_dict())
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400

@app.route('/api/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    product = Product.query.get_or_404(product_id)
    try:
        db.session.delete(product)
        db.session.commit()
        return jsonify({'message': 'Product deleted successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400

@app.route('/api/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    product = Product.query.get_or_404(product_id)
    return jsonify(product.to_dict())

# Ruta principal con interfaz web
@app.route('/')
def index():
    return render_template('index.html')

# Ruta para inicializar la base de datos con datos de ejemplo
@app.route('/api/init-db', methods=['POST'])
def init_database():
    try:
        # Crear tablas
        db.create_all()
        
        # Verificar si ya hay datos
        if Product.query.count() == 0:
            # Datos de ejemplo
            sample_products = [
                Product(name='Nike Air Max', category='Zapatillas', price=129.99, stock_quantity=50, description='Zapatillas deportivas cómodas'),
                Product(name='Adidas T-Shirt', category='Ropa', price=29.99, stock_quantity=100, description='Camiseta deportiva de algodón'),
                Product(name='Wilson Tennis Racket', category='Equipamiento', price=89.99, stock_quantity=25, description='Raqueta de tenis profesional'),
                Product(name='Under Armour Shorts', category='Ropa', price=39.99, stock_quantity=75, description='Shorts deportivos transpirables'),
                Product(name='Nike Basketball', category='Pelotas', price=24.99, stock_quantity=30, description='Balón de baloncesto oficial'),
                Product(name='Adidas Running Shoes', category='Zapatillas', price=79.99, stock_quantity=40, description='Zapatillas para correr'),
                Product(name='Puma Track Suit', category='Ropa', price=59.99, stock_quantity=60, description='Traje deportivo completo'),
                Product(name='Wilson Volleyball', category='Pelotas', price=19.99, stock_quantity=35, description='Pelota de voleibol oficial')
            ]
            
            for product in sample_products:
                db.session.add(product)
            
            db.session.commit()
            return jsonify({'message': 'Database initialized with sample data', 'products_added': len(sample_products)})
        else:
            return jsonify({'message': 'Database already contains data'})
            
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    with app.app_context():
        # Crear tablas automáticamente al iniciar
        db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True) 