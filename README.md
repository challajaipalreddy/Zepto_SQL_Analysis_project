# Zepto_SQL_Analysis_project
# 🛒 Zepto E-commerce SQL Data Analyst Project

This is a complete, real-world **Data Analyst portfolio project** based on an e-commerce inventory dataset scraped from **Zepto** — one of India's leading quick-commerce startups.

It simulates how SQL is used in actual retail analytics workflows: from **cleaning messy catalog data**, to **calculating inventory value**, and **uncovering business insights** using advanced PostgreSQL features.

---

## 🎯 Who Is This For?
- Aspiring **Data Analysts** building a SQL-heavy project for their resume
- SQL learners who want **hands-on practice** with a real-world dataset
- Interview candidates preparing for **e-commerce or product analyst roles**

---

## 📦 Dataset Overview

Each row is a SKU (Stock Keeping Unit) that includes pricing, category, quantity, and availability.

| Column                | Description                                    |
|-----------------------|------------------------------------------------|
| `sku_id`              | Unique ID for each product (auto-generated)    |
| `category`            | Product category (Fruits, Snacks, Beverages...)|
| `name`                | Product name                                   |
| `mrp`                 | Maximum Retail Price (in ₹)                    |
| `discountPercent`     | % discount applied                             |
| `discountedSellingPrice` | Final price after discount (in ₹)            |
| `availableQuantity`   | Inventory quantity available                   |
| `weightInGms`         | Product weight in grams                        |
| `outOfStock`          | Whether product is out of stock (true/false)   |
| `quantity`            | Pack size or quantity per unit                 |

---

## 🔧 Project Workflow

### 1️⃣ Table Creation
```sql
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

```
## 2️⃣ Data Import
\copy zepto(category, name, mrp, discountPercent, availableQuantity,
            discountedSellingPrice, weightInGms, outOfStock, quantity)
FROM 'data/zepto_v2.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');


## 3️⃣ Data Exploration
Checked null values and schema
Counted total rows
Identified distinct product categories
Found duplicate product names
Compared in-stock vs out-of-stock products


# 4️⃣ Data Cleaning
Removed rows with MRP = 0 or discountedSellingPrice = 0.

Converted mrp and discountedSellingPrice from paise to rupees
```sql
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;


```
##💼 How to Use This Project
Clone the repository

Open the .sql file in pgAdmin / DBeaver

Import the dataset using \copy or pgAdmin's import GUI

Run each section: creation → cleaning → analysis



