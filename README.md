# Inventory-Inefficiencies-Using-Advanced-SQL-Analytics
SQL-driven inventory monitoring and optimization solution for the Urban Retail Co. company.


---

````markdown
# 🛒 Urban Retail Co. — Inventory Optimization & Forecasting

This repository contains the complete data-driven solution developed for Urban Retail Co. to enhance inventory management, reduce stockouts, and improve sales forecasting using **SQL** and **Power BI**.

## 📁 Repository Structure

```bash
├── 📂 sql_queries/             # All advanced SQL scripts used
│   ├── inventory_turnover.sql
│   ├── reorder_point_estimation.sql
│   ├── stockout_rate.sql
│   └── velocity_fast_slow_movers.sql
│
├── 📂 tables/                  # Generated normalized tables (.csv/.sql)
│   ├── Inventory_Facts.csv
│   ├── Products.csv
│   ├── Stores.csv
│   └── Dates.csv
│
├── 📂 dashboard/               # Power BI KPI dashboard
│   ├── Urban_KPI.pbix         # Power BI project file
│   └── dashboard_screenshot.png
│
├── 📂 erd/
│   └── inventory_erd.png      # ERD visual generated using QuickDBD
│
├── 📂 summary/
│   ├── executive_summary.pdf  # Key findings and business recommendations
│   └── summary_kpis.csv       # Output of summary KPI queries
│
├── README.md                  # You're here!
````

---

## 🔍 Project Overview

This project aims to help Urban Retail Co. improve decision-making in inventory and supply chain by:

* Reducing **stockouts** through dynamic reorder tracking
* Improving **sales forecasting** using historical trends
* Identifying **supplier inconsistencies** in refill patterns
* Highlighting **fast vs slow movers** by product and season

---

## 🧮 SQL Tasks Completed

✔️ Inventory Turnover Analysis
✔️ Stock Level & Stockout Rate Reporting
✔️ Reorder Point Estimation via Rolling Averages
✔️ Fast vs Slow Movers via Velocity Metrics
✔️ Forecast Demand Trends by Category & Season
✔️ Supplier Performance Tracking (Order-Without-Refill Events)

SQL engine: **SQLite**
IDE used: **VS Code with SQLite extension**

---

## 📊 Power BI KPI Dashboard

The dashboard includes:

* Total Stock, Sales, Stockout %
* Sales by Category, Season, Store ID
* Forecast vs Actual Sales Trends
* Refill Gaps (Orders with No Refill)
* 1-Month Forecasts with Slider

> 📂 `dashboard/Urban_KPI.pbix` can be opened directly in Power BI Desktop.

---

## 🗂 ERD Schema

* 1 Fact Table: `Inventory_Facts`
* 3 Dimensions: `Products`, `Stores`, `Dates`
* All foreign keys normalized and indexed for efficiency

![ERD](./erd/inventory_erd.png)

---

## 📈 Key Results

* **Stockout Rate**: 6.67%
* **Inventory Turnover**: >1.5 for Clothing and Toys
* **Unrefilled Orders**: \~12.4M occurrences in 2 years
* **Forecast Deviation**: Winter months underpredicted

See: [`summary/executive_summary.pdf`](./summary/executive_summary.pdf)

---

## ✅ How to Run

1. Open `Urban_KPI.pbix` in Power BI Desktop
2. Import `.csv` tables from the `tables/` directory
3. Run SQL scripts in `sql_queries/` using SQLite or any compatible SQL IDE

---

Developed by: **Shivrajsinh Bhosale**
Email: `shivrajsinh.bhosale@iitgn.ac.in`
For questions or feedback, feel free to open an issue or contact directly!

---

```

