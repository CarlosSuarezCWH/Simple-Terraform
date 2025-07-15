-- Create a sports store database
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO products (name, category, price, stock_quantity, description) VALUES
('Basketball', 'Basketball', 29.99, 50, 'Official size 7 basketball'),
('Running Shoes', 'Running', 89.99, 30, 'Lightweight running shoes'),
('Yoga Mat', 'Yoga', 24.99, 40, 'Non-slip yoga mat'),
('Dumbbell Set', 'Strength', 149.99, 15, 'Adjustable dumbbell set 5-50 lbs'),
('Tennis Racket', 'Tennis', 79.99, 20, 'Professional tennis racket');

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (product_id) REFERENCES products(id)
);
