SELECT COUNT(*) FROM mock_data WHERE customer_email IS NULL;

SELECT product_category, COUNT(*) 
FROM mock_data
GROUP BY product_category
ORDER BY COUNT(*) DESC;

SELECT customer_country, COUNT(*) 
FROM mock_data
GROUP BY customer_country
ORDER BY COUNT(*) DESC;

SELECT 
  EXTRACT(MONTH FROM sale_date) AS sale_month, 
  COUNT(*) 
FROM mock_data
GROUP BY sale_month
ORDER BY sale_month;

SELECT AVG(customer_age) FROM mock_data;
