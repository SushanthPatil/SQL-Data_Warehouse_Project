/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

create view gold.dim_customers as
Select 
	ROW_NUMBER () over (ORDER by cst_id) as Customer_Key,
	ci.cst_id as customer_id,
    ci.cst_key as customer_number,
    ci.cst_firstname as First_name,
    ci.cst_lastname as Last_name,
    ci.cst_marital_status as Marital_Status,
    case when ci.cst_gndr != 'n/a' then ci.cst_gndr -- CRM is the master for the gender info
		else coalesce (ca.gen, 'n/a')
	end as Gender, 
	ca.bdate as Birth_date,
    ci.cst_create_date as Create_Date,
	la.cntry as Country
from silver.crm_cust_info as ci
left join Silver.erp_cust_az12 as ca
on	ci.cst_key = ca.cid
left join Silver.erp_loc_a101 la
on	ci.cst_key = la.cid



-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE view gold.dim_products as
Select 
	PN.prd_id AS Product_id,
	pn.prd_key as Product_Key,
	pn.prd_nm as Product_Name,
	pn.cat_id as Categroy_id,
	pc.cat as Category,
	pc.subcat as Sub_category,
	pc.maintenance as Maintainence,
	pn.prd_cost as Product_cost,
	pn.prd_line as Product_Line,
	pn.prd_start_dt as Product_Start_Date
from Silver.crm_prd_info pn
left join Silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id
where pn.prd_end_dt is null; --Filter out all hysterical data
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

create view gold.fact_sales as
Select 
	sd.sls_ord_num as Order_Number,
	pr.Product_key as Product_key,
	cu.customer_id as Customer_id,
	sd.sls_order_dt as Order_Date,
	sd.sls_ship_dt as Shipping_Date,
	sd.sls_due_dt as Due_date,
	sd.sls_sales as Sales,
	sd.sls_quantity as Quantity,
	sd.sls_price as Price
from Silver.crm_sales_details sd
left join Gold.dim_Products pr
on sd.sls_prd_key = pr.Product_key
left join gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id;
GO
