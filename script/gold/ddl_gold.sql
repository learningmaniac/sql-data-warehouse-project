


create view gold.dime_customer as
select
	row_number() over(order by ci.cst_create_date) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as First_Name,
	ci.cst_lastname Last_Name,
	la.cntry as Country,
	ci.cst_marital_status as Marital_Status,
	ca.bdate as brith_date,
	case 
		when ci.cst_gndr != 'n/a' then ci.cst_gndr
		else coalesce(ca.gen,'n/a')
	end as gender,
	cst_create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la on ci.cst_key = la.cid;


create or alter view gold.dim_product as	
select
	row_number() over(order by pi.prd_start_dt, pi.prd_key) as product_key,
	pi.sls_prd_id as product_id,
	pi.prd_key as product_number,
	pi.prd_nm as product_name,
	pi.prd_cost as cost,
	pi.prd_Line as product_line,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	prd_start_dt
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2 pc on pc.id = pi.cat_id
where prd_end_dt is null; -- Removing the Historical data



create or alter view gold.fact_sales
select
	sls_ord_num as order_number,
	pr.product_key,
	cu.customer_key,
	sls_order_dt as order_date,
	sls_ship_dt as shiped_date,
	sls_due_dt as due_date,
	sls_sales as sales_amount,
	sls_quantity as quantity,
	sls_price as price
from silver.CRM_SALES_INFO sd
left join gold.dim_product pr
on sd.sls_prd_key = pr.product_id
left join gold.dim_customer cu
on sd.sls_cust_id = cu.customer_id;
