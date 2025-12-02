show databases;

use aurea_dev;

show tables;

create database aurea_dev;
use aurea_devsys_config;
show databases;
show tables;

CREATE TABLE colors (
    color_id   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    hex_code   CHAR(7)       -- optional (#FFFFFF)
);

INSERT INTO colors (name, hex_code)
VALUES
('NA', ''),
('Red', '#FF0000'),
('Blue', '#0000FF'),
('Black', '#000000'),
('White', '#FFFFFF');


CREATE TABLE sizes (
    size_id    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL
);

INSERT INTO sizes (name)
VALUES
('S'),
('M'),
('L'),
('XL'),
('250 gm'),
('500 gm'),
('1 kg'),
('1.2 kg'),
('250 ml'),
('500 ml'),
('1 Litre'),
('1.2 Litre');

CREATE TABLE categories (
    category_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    parent_id BIGINT UNSIGNED DEFAULT NULL,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

INSERT INTO categories (name) VALUES
('Ghee'), ('Honey'), ('Haldi'), ('Dal'), ('Makhana'), ('Candy');

CREATE TABLE products (
    product_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    brand_id BIGINT,
    brand VARCHAR(100),
    category_id BIGINT UNSIGNED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

INSERT INTO products (name, description, category_id)
VALUES
('Raw Unprocessed Litchi Blossom Honey', 'A pure and natural honey crafted from the nectar of litchi blossoms. Known for its light texture, fruity aroma, and mildly sweet taste, this honey is collected without heat processing or filtration to preserve its natural enzymes and nutrients.',2),
('Wild Forest Honey','Honey is a natural food and comes with multiple uses and benefits and should be used in its pure form. Pure Honey is also a healthy alternative to sugar and is considered one of the most wonderful gifts that nature has ever gifted to mankind. Honey for weight loss is also a common use of Honey for consumers, also honey is a natural source of energy, boosts immunity and contains antioxidants. Saffola Honey Active is made with multiflora honey including delicious Sundarban Forest honey - a pure and natural honey. It is naturally sweet, aromatic and fruity. Start your day with a delightful spoon of Saffola Honey Active. It is tested and complies with 22 rigorous quality checks of FSSAI. Each bottle of Saffola Honey Active is 100% Pure and free from Sugar adulteration and comes with a Purity certificate that is made available to its consumers. You can scan QR code at back of the pack and download your purity certificate. Some of the uses of Saffola Honey Active - with warm water in morning for weight management, as a sugar substitute, in breakfast or with warm milk , can be used in making sweets and pancakes and many more uses where pure honey is used.',2),
('Mustard Honey','Experience the purest form of honey with Bonphool Mustard Honey, sourced directly from the pristine regions of North and South Dinajpur. This 100% pure, raw, and natural honey is a rich source of antioxidants, iron, calcium, Vitamin A, and Vitamin C, which help boost immunity, promote bone health, and support skin and eye health. By choosing Bonphool, you are not just nourishing your body – you are supporting traditional honey collectors in West Bengal and aiding in the conservation of the endangered Royal Bengal Tiger in the Sundarbans. Your purchase helps protect these collectors from the dangers they face, including tiger attacks, while contributing to the preservation of these majestic creatures. Uses: Enjoy a spoonful each morning for a natural energy boost. Add to teas, smoothies, or recipes as a healthy sweetener. Drizzle over pancakes, yogurt, or toast for a delicious and unique flavor. Mix with water or any drink for effortless sweetness and goodness.',2),
('Bilona Desi Cow Ghee','Our A2 Ghee begins its journey with fresh milk from free-grazing indigenous cows. The milk is gently boiled, allowed to cool naturally, and set overnight with a traditional natural starter to form rich curd. At dawn, this curd is slowly hand-churned using the classic Bilona method, yielding pure, aromatic ghee. Every spoonful carries the warmth of tradition and the purity of wholesome, handcrafted goodness.',1),
('Haldi (Turmeric)','Pure, golden-grade turmeric powder sourced from high-curcumin turmeric roots. This aromatic and vibrant spice is widely valued for its medicinal, culinary, and wellness properties.',3),
('Whole Moong (Green Gram)','Whole green moong beans rich in protein, fibre, and essential nutrients. These naturally wholesome for sprouts, and salads.',4),
('Whole Masoor (Red Lentils)','Nutrient-packed whole masoor dal, known for its earthy flavour and fast-cooking nature. A staple in Indian kitchens, it provides a wholesome meal rich in protein and iron.',4),
('Honey Aawla Candy','A delightful wellness candy made by infusing vitamin-rich Aawla (Indian Gooseberry) with pure honey. A tasty, healthy treat that supports daily immunity and digestion.',6),
('Makhana','Our Makhana begins its journey in the lush wetlands of the Mithila region, where lotus plants are grown organically by local farmers using age-old, sustainable methods. The seeds are hand-picked at sunrise, sun-dried with care, and slowly roasted to preserve their natural crunch and rich nutrient profile. Every flake is meticulously sorted to ensure purity and premium quality. Rooted in the heritage of Mithila and crafted with mindful, local farming, each handful delivers wholesome nourishment and the true taste of traditionally grown Makhana.', 5)
;

CREATE TABLE product_variants (
    variant_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED NOT NULL,
    sku VARCHAR(100) UNIQUE,
    color_id BIGINT UNSIGNED NOT NULL,
    size_id BIGINT UNSIGNED NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    images TEXT,
    is_active      BOOLEAN DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (color_id) REFERENCES colors(color_id),
    FOREIGN KEY (size_id) REFERENCES sizes(size_id),
    UNIQUE (product_id, color_id, size_id)  -- each combo unique
);

INSERT INTO product_variants (product_id, sku, color_id, size_id, price,images)
VALUES
(2,'WLD-HNY-1',1,6,400,'images/mustard_honey.png images/mustard_honey2.png'),
(2,'WLD-HNY-2',1,8,800,'images/mustard_honey.png images/mustard_honey2.png'),
(3,'MST-HNY-1',1,6,400,'images/mustard_honey.png images/mustard_honey2.png'),
(3,'MST-HNY-2',1,8,800,'images/mustard_honey.png images/mustard_honey2.png'),
(1,'LTH-HNY-1',1,6,400,'images/litchi_honey.png'),
(1,'LTH-HNY-2',1,8,800,'images/litchi_honey.png'),
(4,'BLN-GHE-1',1,10,820,'images/bilona_desi_cow_ghee.png images/bilona_cow_ghee.png'),
(4,'BLN-GHE-2',1,11,1499,'images/bilona_desi_cow_ghee.png images/bilona_cow_ghee.png'),
(5,'HLD-TUM-2',1,5,100,'images/haldi.png'),
(9,'MKH-MKH-1',1,8,1000,'images/makhana.png');

CREATE TABLE users (
    user_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    mobile VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('user','admin') DEFAULT 'user',
    gender VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    address_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED,
    name VARCHAR(100),
    phone VARCHAR(20),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
INSERT INTO addresses 
(user_id, name, phone, address_line1, city, state, country, postal_code, is_default)
VALUES
(1, 'John Doe', '9876543210', '123 Street', 'NYC', 'NY', 'USA', '10001', TRUE);



CREATE TABLE product_images (
    image_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED,
    image_url VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO product_images (product_id, image_url, is_primary)
VALUES (1, 'img/smartphone1.jpg', TRUE);


CREATE TABLE carts (
    cart_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE cart_items (
    cart_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cart_id BIGINT UNSIGNED,
    variant_id BIGINT UNSIGNED,
    quantity INT,
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id)
);


CREATE TABLE wishlist (
    wishlist_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED,
    product_id BIGINT UNSIGNED,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE TABLE orders (
    order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED,
    address_id BIGINT UNSIGNED,
    total_amount DECIMAL(10,2),
    status ENUM('Pending','Processing','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);

CREATE TABLE order_items (
    order_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED,
    variant_id BIGINT UNSIGNED,
    price DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id)
);

CREATE TABLE transactions (
    transaction_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED,
    amount DECIMAL(10,2),
    payment_method ENUM('COD','Card','UPI','NetBanking'),
    status ENUM('Success','Failed','Pending'),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE product_reviews (
    review_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED,
    user_id BIGINT UNSIGNED,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE attributes (
    attribute_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    attribute_name VARCHAR(100),
    attribute_type ENUM('text','number','boolean','list') DEFAULT 'text'
);
INSERT INTO attributes (attribute_name) VALUES
('RAM'), ('Storage'), ('Battery'), ('Processor'), ('Screen Size');


CREATE TABLE product_attribute_values (
    pav_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED,
    attribute_id BIGINT UNSIGNED,
    value TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (attribute_id) REFERENCES attributes(attribute_id)
);
INSERT INTO product_attribute_values (product_id, attribute_id, value) VALUES
(1, 1, '8 GB'),
(1, 2, '128 GB'),
(1, 3, '4500 mAh'),
(1, 4, 'Snapdragon 888'),
(1, 5, '6.4 inches');


CREATE TABLE product_features (
    feature_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED,
    feature_text VARCHAR(255),
    sort_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO product_features (product_id, feature_text)
VALUES
(1, 'Fast Charging'),
(1, '5G Enabled'),
(1, 'Triple Camera System');

CREATE TABLE product_ingredients (
    ingredient_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED,
    ingredient_name VARCHAR(255),
    percentage VARCHAR(50), -- optional
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO product_ingredients (product_id, ingredient_name, percentage)
VALUES
(20, 'Aloe Vera Extract', '15%'),
(20, 'Vitamin E', '2%'),
(20, 'Fragrance', NULL);


CREATE TABLE product_benefits (
    benefit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED,
    benefit_text VARCHAR(255),
    sort_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO product_benefits (product_id, benefit_text)
VALUES
(1, 'Boosts immunity'),
(1, '100% Organic ingredients'),
(1, 'Safe for kids');


DELIMITER $$

CREATE FUNCTION generate_sku(
    brand VARCHAR(100),
    product_name VARCHAR(255),
    attribute VARCHAR(100),
    id BIGINT
)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN CONCAT(
        UPPER(LEFT(brand, 3)), '-',
        UPPER(REPLACE(LEFT(product_name, 5), ' ', '')), '-',
        UPPER(attribute), '-',
        LPAD(id, 4, '0')
    );
END $$

DELIMITER ;
