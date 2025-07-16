import os
from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host=os.environ.get('DB_HOST', 'localhost'),
        user=os.environ.get('DB_USER', 'admin'),
        password=os.environ.get('DB_PASS', ''),
        database=os.environ.get('DB_NAME', 'sportsstore')
    )

@app.route('/products', methods=['GET'])
def get_products():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM products')
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(products)

@app.route('/products', methods=['POST'])
def add_product():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        'INSERT INTO products (name, category, price, stock_quantity, description) VALUES (%s, %s, %s, %s, %s)',
        (data['name'], data['category'], data['price'], data['stock_quantity'], data.get('description', ''))
    )
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Product added'}), 201

@app.route('/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        'UPDATE products SET name=%s, category=%s, price=%s, stock_quantity=%s, description=%s WHERE id=%s',
        (data['name'], data['category'], data['price'], data['stock_quantity'], data.get('description', ''), product_id)
    )
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Product updated'})

@app.route('/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM products WHERE id=%s', (product_id,))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Product deleted'})

@app.route('/')
def index():
    return "<h1>Sports Store API</h1><p>Use /products endpoint for CRUD operations.</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000) 