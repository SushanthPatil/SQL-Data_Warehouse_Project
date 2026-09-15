/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

use DataWarehouse;

if object_id('bronze.crm_cust_info', 'u') is not null
	drop table Bronze.crm_cust_info;
create table Bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname Nvarchar(50),
	cst_lastname Nvarchar(50),
	cst_material_status Nvarchar(50),
	cst_gndr NVarchar(50),
	cst_create_date DATE
);

if object_id('bronze.crm_prd_info', 'u') is not null
	drop table Bronze.crm_prd_info;
create table bronze.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
);

if object_id('bronze.crm_sales_details', 'u') is not null
	drop table Bronze.crm_sales_details;
create table bronze.crm_sales_details (
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id Int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);

if object_id('bronze.erp_loc_a101', 'u') is not null
	drop table Bronze.erp_loc_a101;
create table bronze.erp_loc_a101(
	cid NVARCHAR (50),
	cntry nvarchar(50)
);

if object_id('bronze.erp_cust_az12', 'u') is not null
	drop table Bronze.erp_cust_az12;
create table bronze.erp_cust_az12 (
	cid nvarchar(50),
	bdate date,
	gen nvarchar(50)
);

if object_id('bronze.erp_px_cat_g1v2', 'u') is not null
	drop table Bronze.erp_px_cat_g1v2;
create table bronze.erp_px_cat_g1v2 (
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50)
);
