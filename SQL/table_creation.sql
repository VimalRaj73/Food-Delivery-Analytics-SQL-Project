CREATE database Food_Delivery_db;

USE Food_Delivery_db;

CREATE TABLE Customers(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_name VARCHAR(100),
	city VARCHAR(100),
	signup_date DATE
    );
    
CREATE TABLE Restaurants(
	restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(100),
    cuisine VARCHAR(100),
    city VARCHAR(100)
    );
    
CREATE TABLE Orders(
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
	restaurant_id INT,
    order_date DATE,
    order_amount FLOAT,
    order_status VARCHAR(100),
    
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
    
    );
    
CREATE TABLE Delivery(
	delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    delivery_time INT,
    delivery_status VARCHAR(100),
    
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
    );
    
CREATE TABLE Payments(
	payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(100),
    payment_status VARCHAR(100),
    
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
    );
    



