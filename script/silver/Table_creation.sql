

/*
=============================================================================================
This script Contain the table creation(Silver) script for two sorce erp and crm systems
First we check if the table exist, if it does than we drop it.
Create the table structure

Executiing this script delete all the data in tables.

=============================================================================================
*/



---- Table for CRM 

IF OBJECT_ID('SILVER.CRM_CUST_INFO','U') IS NOT NULL
	DROP TABLE SILVER.CRM_CUST_INFO;

CREATE TABLE SILVER.CRM_CUST_INFO (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('SILVER.CRM_PRD_INFO','U') IS NOT NULL
	DROP TABLE SILVER.CRM_PRD_INFO;

CREATE TABLE SILVER.CRM_PRD_INFO (
prd_id INT,
prd_key NVARCHAR(50),
cat_id NVARCHAR(50),
sls_prd_id NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost NVARCHAR(50),
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('SILVER.CRM_SALES_INFO','U') IS NOT NULL
	DROP TABLE SILVER.CRM_SALES_INFO;

CREATE TABLE SILVER.CRM_SALES_INFO (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--- Tables for ERP

IF OBJECT_ID('SILVER.ERP_CUST_AZ12','U') IS NOT NULL
	DROP TABLE SILVER.ERP_CUST_AZ12;

CREATE TABLE SILVER.ERP_CUST_AZ12 (
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50)
);

IF OBJECT_ID('SILVER.ERP_LOC_A101','U') IS NOT NULL
	DROP TABLE SILVER.ERP_LOC_A101;

CREATE TABLE SILVER.ERP_LOC_A101 (
CID NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('SILVER.ERP_PX_CAT_G1V2','U') IS NOT NULL
	DROP TABLE SILVER.ERP_PX_CAT_G1V2;

CREATE TABLE SILVER.ERP_PX_CAT_G1V2 (
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


