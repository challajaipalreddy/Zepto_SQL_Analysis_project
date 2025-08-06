drop table if exists zepto;
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);

 	
select * from zepto;



----------Data Exploration------------

---count rows----
select count(*) from zepto;


--------Check For Null values------
select * from zepto
where name is NULL or 
mrp is null or
discountpercent is null or 
availablequantity is null or
discountedsellingprice is null or
weightingms is null or outofstock is null or
quantity is null;

-----Q1: Get all products in the 'Fruits & Vegetables' category.

select * from zepto
where category = 'Fruits & Vegetables';

--------Q2: Get distinct product categories.----------
select distinct category from zepto;

----------Q3. Get all the products from each category-----
select category,name from zepto;
----------Q3: List all products that are out of stock.----------
select name as out_of_stock_products from zepto
where outofstock = True

-------or---------
select outofstock,count(*)
from zepto
group by outofstock;


------Q4: List top 10 costliest products by MRP.------
select * from zepto
order by mrp desc
limit 10


---------Q5: Count the number of products in each category.-------------

select category,count(*) as product_count
from zepto
group by category
order by product_count desc


------------Q6: Average discount percent per category.----------
select category, floor(avg(discountpercent)) as Avg_Discount
from zepto
group by category;

---------Q7: Calculate the actual discount amount for each product.----------
select name,mrp,discountpercent,(mrp - discountedsellingprice) As Discount_amount,discountedsellingprice as Final_price
from 
zepto;





--------Q8: Products where discount percent doesn’t match actual discount.----------
SELECT *
FROM zepto
WHERE discountpercent != ROUND((mrp - discountedSellingPrice) * 100.0 / mrp);



-------- Window Functions--------
---------Q9: Rank products within each category by discounted price.----------
select category,name,discountedsellingprice as Final_price,
rank() over(partition by category order by discountedsellingprice desc) as price_rank
from zepto;



--------Q10: Running total of available quantity per category.---------(window function(cummulative sum))
SELECT name, Category, availableQuantity,
       SUM(availableQuantity) OVER (PARTITION BY Category ORDER BY name) AS running_total
FROM zepto;



-------Sub Queires----------
----------Q11: Get products with price higher than the average discounted price.----------
select * from zepto
where discountedsellingprice > (select avg(discountedsellingprice) from zepto);

--select avg(discountedsellingprice) from zepto;



------- 7. Boolean & Conditions
--------Q12: Get products that are in stock and have more than 3 units available.

select * from zepto
where outofstock is False and availablequantity > 3
order by availablequantity asc;

--------🔹 8. Advanced Aggregation
------------Q13: Total weight and total value (after discount) per category.

select category,sum(availablequantity) as Total_stock,sum(discountedsellingprice) as total_cost
from zepto
group by category
order by total_cost desc;



---------Q14. Total cost for the available quantity---------
select * from zepto;

select name,availablequantity,discountedsellingprice,(availablequantity * discountedsellingprice) as Total_cost_fro_availableQuantity
from zepto;


-------🔹 9. Text Search and String Functions
------Q14: Find products containing the word 'Onion'.

select * from zepto
where name like '%Onion%';


-----Q15: Count of items with more than one word in their name.
select count(*) from zepto
where name like '% %';



---------🔸 Q16. Find the top 3 costliest products in each category by discounted price.
select * from(select *,
rank() over(partition by category order by mrp desc) as price_rank
from zepto)
where price_rank <=10;

--------10 items----------
select * from zepto
limit 10;



-------- Q17. Which categories have more than 500 total available quantity?------
select category,sum(availablequantity) as Total_Quantity from zepto
group by category
having sum(availablequantity) > 500
order by Total_Quantity desc
limit 4
offset 2;


-------Q18. Calculate effective price per gram for each product.------

SELECT name, Category, discountedSellingPrice, weightInGms,
       ROUND(discountedSellingPrice * 1.0 / NULLIF(weightInGms, 0), 2) AS price_per_gram
FROM zepto;

-----Q19. Find all products with quantity > availableQuantity.-----

SELECT *
FROM zepto
WHERE quantity > availableQuantity;

--------Q20. Get category-wise minimum and maximum price product.--------

SELECT DISTINCT ON (Category) Category, name, discountedSellingPrice
FROM zepto
ORDER BY Category, discountedSellingPrice desc;


------Q21. Count how many products are marked as out of stock in each category.
select category,count(*) as out_of_stock
from zepto
where outofstock = true
group by category
order by out_of_stock desc



-------------------------------------------------------------------
select * from zepto
where mrp =0;
------------------------------------------------------------------
delete from zepto
where mrp = 0;

-----------Convert paise to rupeees-----------
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

----------Q.22. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;




---Q23.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;



----------- Q24. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;



-------
-- Q25. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q26.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q27.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


-------- Q28. Products with maximum quantity in stock (per category)-
SELECT *
FROM (
  SELECT *, RANK() OVER (PARTITION BY category ORDER BY availableQuantity DESC) AS rnk
  FROM zepto
) sub
WHERE rnk = 1;

------Q29. Products with the same name in multiple categories (potential duplicates)---

SELECT name, COUNT(DISTINCT category) AS category_count
FROM zepto
GROUP BY name
HAVING COUNT(DISTINCT category) > 1;


------- Q30. Which categories have products with MRP above ₹1000?
SELECT DISTINCT category
FROM zepto
WHERE mrp > 1000;

