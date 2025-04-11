INSERT INTO states(state_name)
SELECT DISTINCT store_state FROM mock_data;

INSERT INTO product_categories(category)
SELECT DISTINCT product_category FROM mock_data;

INSERT INTO pet_categories(category)
SELECT DISTINCT pet_category FROM mock_data;

INSERT INTO pet_types(type)
SELECT DISTINCT customer_pet_type FROM mock_data;

INSERT INTO cities(city_name)
SELECT DISTINCT store_city FROM mock_data
UNION
SELECT DISTINCT supplier_city FROM mock_data;

INSERT INTO countries(country_name)
SELECT DISTINCT customer_country FROM mock_data
UNION
SELECT DISTINCT seller_country FROM mock_data
UNION
SELECT DISTINCT store_country FROM mock_data
UNION
SELECT DISTINCT supplier_country FROM mock_data;

INSERT INTO product_colors(color)
SELECT DISTINCT product_color FROM mock_data;

INSERT INTO product_brands(brand_name)
SELECT DISTINCT product_brand FROM mock_data;



INSERT INTO dim_pets(pet_category_id, type_id, pet_name, pet_breed)
SELECT DISTINCT 
    ct.pet_category_id, 
    tp.pet_type_id,       
    customer_pet_name, 
    customer_pet_breed
FROM mock_data as mock
JOIN pet_categories AS ct ON mock.pet_category = ct.category
JOIN pet_types as tp ON mock.customer_pet_type = tp.type;



INSERT INTO dim_suppliers(name, contact, email, phone, address, city_id, country_id)
SELECT DISTINCT 
    supplier_name, 
    supplier_contact, 
    supplier_email,     
    supplier_phone,     
    supplier_address, 
    city.city_id, 
    c.country_id
FROM mock_data as mock
JOIN countries as c ON mock.supplier_country = c.country_name
JOIN cities as city ON mock.supplier_city = city.city_name;



INSERT INTO dim_customers(first_name, last_name, age, email, country_id, postal_code)
SELECT DISTINCT 
    customer_first_name, 
    customer_last_name, 
    customer_age, 
    customer_email,           
    c.country_id,             
    customer_postal_code      
FROM mock_data AS mock
JOIN countries as c ON mock.customer_country = c.country_name;



INSERT INTO dim_sellers(first_name, last_name, seller_email, seller_country_id, postal_code)
SELECT DISTINCT 
    seller_first_name, 
    seller_last_name, 
    seller_email,            
    c.country_id,            
    seller_postal_code      
FROM mock_data AS mock
JOIN countries AS c ON mock.seller_country = c.country_name;



INSERT INTO dim_stores(name, location, city_id, state_id, country_id, phone, email)
SELECT DISTINCT 
    store_name, 
    store_location, 
    city.city_id, 
    st.state_id, 
    c.country_id, 
    store_phone,      
    store_email       
FROM mock_data AS mock
JOIN cities AS city ON mock.store_city = city.city_name
JOIN states AS st ON mock.store_state = st.state_name
JOIN countries AS c ON mock.store_country = c.country_name;



INSERT INTO dim_products(
    name, 
    category_id, 
    price, 
    quantity, 
    weight, 
    color_id, 
    size, 
    brand_id, 
    material, 
    description, 
    rating, 
    reviews, 
    release_date, 
    expiry_date
)
SELECT DISTINCT
    product_name, 
    cat.category_id, 
    product_price, 
    product_quantity, 
    product_weight, 
    col.color,           
    product_size, 
    br.product_brand_id, 
    product_material,        
    product_description, 
    product_rating, 
    product_reviews, 
    product_release_date, 
    product_expiry_date
FROM mock_data AS mock
JOIN product_categories AS cat ON mock.product_category = cat.category
JOIN product_colors AS col ON mock.product_color = col.color  
JOIN product_brands AS br ON mock.product_brand = br.brand_name;



INSERT INTO fact_sales(customer_id, seller_id, product_id, store_id, supplier_id, pet_id, sell_date, sale_total_price)
SELECT
    cust.customer_id,
    sell.seller_id,
    prod.product_id,
    stor.store_id,
    supp.supplier_id,
    pt.pet_id,
    mock.sale_date,
    mock.sale_total_price
FROM mock_data AS mock
JOIN dim_customers AS cust ON mock.id = cust.customer_id
JOIN dim_sellers AS sell ON mock.id = sell.seller_id
JOIN dim_products AS prod ON mock.id = prod.product_id
JOIN dim_stores AS stor ON mock.id = stor.store_id
JOIN dim_suppliers AS supp ON mock.id = supp.supplier_id
LEFT JOIN dim_pets AS pt ON mock.id = pt.pet_id;