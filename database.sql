show databases;

use aurea_dev;

show tables;

create database aurea_dev;
use aurea_devsys_config;
show databases;
show tables;
CREATE TABLE notes (
  id integer PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  contents TEXT NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO notes (title, contents)
VALUES 
('My First Note', 'A note about something'),
('My Second Note', 'A note about something else');
SELECT * FROM NOTES;
SELECT * FROM products;

CREATE TABLE products (
    product_id      BIGINT PRIMARY KEY,
    name            VARCHAR(255) NOT NULL,
    description     TEXT,
    brand_id        BIGINT,
    category_id     BIGINT,
    base_price      DECIMAL(10,2),  -- optional, default price
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE colors (
    color_id   BIGINT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    hex_code   CHAR(7)       -- optional (#FFFFFF)
);
CREATE TABLE sizes (
    size_id    BIGINT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL
);

CREATE TABLE product_variants (
    variant_id     BIGINT PRIMARY KEY,
    product_id     BIGINT NOT NULL,
    color_id       BIGINT NOT NULL,
    size_id        BIGINT NOT NULL,
    sku            VARCHAR(100) UNIQUE,
    price          DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    image_url      TEXT,
    is_active      BOOLEAN DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (color_id) REFERENCES colors(color_id),
    FOREIGN KEY (size_id) REFERENCES sizes(size_id),
    UNIQUE (product_id, color_id, size_id)  -- each combo unique
);

CREATE TABLE product_images (
    image_id    BIGINT PRIMARY KEY,
    variant_id  BIGINT NOT NULL,
    image_url   TEXT NOT NULL,
    sort_order  INT DEFAULT 1,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id)
);


INSERT INTO products (product_id, name, description, brand_id, category_id, base_price)
VALUES
(1, 'Classic Cotton T-Shirt', 'Soft cotton unisex T-shirt available in multiple colors and sizes.', 101, 10, 15.00),
(2, 'Sports Fit Polo', 'Breathable fabric polo for active wear.', 102, 10, 25.00);

INSERT INTO colors (color_id, name, hex_code)
VALUES
(1, 'Red', '#FF0000'),
(2, 'Blue', '#0000FF'),
(3, 'Black', '#000000'),
(4, 'White', '#FFFFFF');

INSERT INTO sizes (size_id, name)
VALUES
(1, 'S'),
(2, 'M'),
(3, 'L'),
(4, 'XL');

INSERT INTO product_variants (variant_id, product_id, color_id, size_id, sku, price, stock_quantity, image_url, is_active)
VALUES
-- Classic Cotton T-Shirt
(1, 1, 1, 1, 'TS-RED-S', 15.00, 25, 'https://example.com/images/tshirt_red_s.jpg', TRUE),
(2, 1, 1, 2, 'TS-RED-M', 15.00, 30, 'https://example.com/images/tshirt_red_m.jpg', TRUE),
(3, 1, 2, 2, 'TS-BLU-M', 16.00, 20, 'https://example.com/images/tshirt_blue_m.jpg', TRUE),
(4, 1, 3, 3, 'TS-BLK-L', 15.00, 15, 'https://example.com/images/tshirt_black_l.jpg', TRUE),
(5, 1, 4, 3, 'TS-WHT-L', 14.50, 10, 'https://example.com/images/tshirt_white_l.jpg', TRUE),

-- Sports Fit Polo
(6, 2, 3, 2, 'POLO-BLK-M', 25.00, 20, 'https://example.com/images/polo_black_m.jpg', TRUE),
(7, 2, 2, 3, 'POLO-BLU-L', 26.00, 18, 'https://example.com/images/polo_blue_l.jpg', TRUE),
(8, 2, 4, 4, 'POLO-WHT-XL', 27.00, 12, 'https://example.com/images/polo_white_xl.jpg', TRUE);

INSERT INTO product_images (image_id, variant_id, image_url, sort_order)
VALUES
-- Red T-shirt (S)
(1, 1, 'https://example.com/images/tshirt_red_front.jpg', 1),
(2, 1, 'https://example.com/images/tshirt_red_back.jpg', 2),

-- Blue T-shirt (M)
(3, 3, 'https://example.com/images/tshirt_blue_front.jpg', 1),
(4, 3, 'https://example.com/images/tshirt_blue_back.jpg', 2),

-- Polo Black (M)
(5, 6, 'https://example.com/images/polo_black_front.jpg', 1),
(6, 6, 'https://example.com/images/polo_black_side.jpg', 2);