

/*
This script is for validating the data transformation.
*/

-- For silver.crm_cust_info

-- check for dulipcats and null values 
-- Expected result 0 rows

select 
	cst_id,
	count(*)
from silver.crm_cust_info
group by cst_id
having count(*) > 1;

-- check for unwanted spaces
-- Expected result 0 rows
select 
 *
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname);


-- Data standardization & Consistency
-- There should be no abbrivation in data 

select
*
from silver.crm_cust_info;

-- check if the Meta column  is added
-- column dwh_create_date is added
select dwh_create_date from silver.crm_cust_info;


--===========================================================================================================================

-- For silver.crm_prd_info

-- check for dulipcats and null values 
-- Expected result 0 rows

select
	prd_id,
	count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1;

-- check for unwanted spaces
-- Expected result 0 rows

select
	*
from silver.crm_prd_info
where prd_nm != trim(prd_nm);

-- Data standardization & Consistency
-- Expected that there should be no abbrivation in data 

select
*
from silver.crm_prd_info;

-- check for NULL values in prd_cost
-- Expected result 0 rows
select
	prd_cost
from silver.crm_prd_info
where prd_cost is NULL;

-- check if prd_start_dt <= prd_end_dt
-- Expected result 0 rows

select
	*
from silver.crm_prd_info
where prd_start_dt > prd_end_dt;

-- check if silver.crm_prd_info.cat_id = SILVER.ERP_PX_CAT_G1V2.cat_id
-- Expected result > 0 rows

select
	cat_id
from silver.crm_prd_info
where cat_id in (select distinct id from bronze.ERP_PX_CAT_G1V2);


/*=======================================================================================*/

-- crm_sales_info

-- Check for key integrity (sls_prd_key, sls_cust_id)
-- Expected result 0 rows
select
*
from bronze.crm_sales_info
where sls_prd_key not in (select distinct sls_prd_key from silver.crm_prd_info);

select
*
from bronze.crm_sales_info
where sls_cust_id not in (select distinct cst_id from silver.crm_cust_info);

select * from silver.crm_sales_info;
select * from bronze.crm_cust_info;

-- The quality and conversation check (sls_order_dt, sls_ship_dt, sls_due_dt)
-- Execpted output is 0 rows(will thought error in silver talbe)

select

from bronze.crm_sales_info
where sls_order_dt <= 0 or len(sls_order_dt) != 8 or sls_order_dt <= 19000101 or sls_order_dt >= 20500101;

-- Check for sls_ship_dt and sls_ship_dt should not be earlier than sls_order_dt
-- Expected output 0 rows
select
*
from silver.crm_sales_info
where sls_ship_dt < sls_order_dt or sls_due_dt < sls_order_dt;

-- check for business rule 
-- total sales = quantity * price
-- Negative, zeros, nulls are not allowed
-- expected 0 rows

select
*
from silver.crm_sales_info
where 
sls_sales != sls_price *  sls_quantity or
sls_sales <= 0 or sls_price <= 0 or sls_quantity <= 0 or
sls_sales is null or sls_price is null or sls_quantity is null;

/*======================================================================================================================================*/

-- erp_cust_az12

-- converting the cid and checking the intrigety
select 
	case
		when cid like 'NAS%' then SUBSTRING(cid,4,LEN(cid))
		else cid
	end as cid
from bronze.erp_cust_az12
where 
case
	when cid like 'NAS%' then SUBSTRING(cid,4,LEN(cid))
	else cid
end
not in (select distinct cst_key from bronze.crm_cust_info);

select * from bronze.crm_cust_info;
select * from bronze.erp_cust_az12;

-- checking if bdate is out-of-range
-- expected result 0 rows
select 
	case 
		when bdate > getdate() then null
		else bdate
	end bdate
from bronze.erp_cust_az12
where 
	case 
		when bdate > getdate() then null
		else bdate
	end
	> getdate();

-- Date integrity and Standartization

select
distinct gen
from bronze.erp_cust_az12;

select 
	case 
		when UPPER(TRIM(gen)) in ('F','FEMALE') then 'Female'
		when UPPER(TRIM(gen)) in ('M','MALE') then 'Male'
		else gen
	end as gen
from bronze.erp_cust_az12;

/*===========================================================================================================================================*/

-- bronze.erp_loc_a101

--- Data conversation

select 
REPLACE(cid,'-','') as cid
from bronze.erp_loc_a101;

-- Data conversation and standartization
select 
distinct cntry,
case
	when cntry = 'DE' then 'Germany'
	when cntry in ('USA','US') then 'United States'
	when cntry = '' or cntry is null then 'n/a'
	else cntry
end as cntry
from bronze.erp_loc_a101;

/*=========================================================================================================================*/

-- erp_px_cat_g1v2

select * from bronze.erp_px_cat_g1v2;

-- checking data integrity

select distinct cat from bronze.erp_px_cat_g1v2;
select distinct subcat from bronze.erp_px_cat_g1v2;
select distinct MAINTENANCE from bronze.erp_px_cat_g1v2;

