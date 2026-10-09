


/*
=============================================================================================
This script Contain the table creation script for two sorce erp and crm systems
First we check if the table exist, if it does than we drop it.
Create the table structure

Executiing this script delete all the data in tables.

=============================================================================================
*/



---- Table for CRM 

IF OBJECT_ID('BRONZE.CRM_CUST_INFO','U') IS NOT NULL
	DROP TABLE BRONZE.CRM_CUST_INFO;

CREATE TABLE BRONZE.CRM_CUST_INFO (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE
);

IF OBJECT_ID('BRONZE.CRM_PRD_INFO','U') IS NOT NULL
	DROP TABLE BRONZE.CRM_PRD_INFO;

CREATE TABLE BRONZE.CRM_PRD_INFO (
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost NVARCHAR(50),
prd_line NVARCHAR(50),
prd_start_dt NVARCHAR(50),
prd_end_dt DATE
);

IF OBJECT_ID('BRONZE.CRM_SALES_INFO','U') IS NOT NULL
	DROP TABLE BRONZE.CRM_SALES_INFO;

CREATE TABLE BRONZE.CRM_SALES_INFO (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

--- Tables for ERP

IF OBJECT_ID('BRONZE.ERP_CUST_AZ12','U') IS NOT NULL
	DROP TABLE BRONZE.ERP_CUST_AZ12;

CREATE TABLE BRONZE.ERP_CUST_AZ12 (
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50)
);

IF OBJECT_ID('BRONZE.ERP_LOC_A101','U') IS NOT NULL
	DROP TABLE BRONZE.ERP_LOC_A101;

CREATE TABLE BRONZE.ERP_LOC_A101 (
CID NVARCHAR(50),
CNTRY NVARCHAR(50)
);

IF OBJECT_ID('BRONZE.ERP_PX_CAT_G1V2','U') IS NOT NULL
	DROP TABLE BRONZE.ERP_PX_CAT_G1V2;

CREATE TABLE BRONZE.ERP_PX_CAT_G1V2 (
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50)
);
