EXEC silver.load_data;


/*
This is the script for Procedure of data loading in silver schema, we are first truncateing the tables than loading the data.
The Tranformation is done in this script.
This script handle the error while loading the data, also the tell the duration of the loading the indivilual tables and whole batch.
Each Load is well formated by printing which table is loading.
*/

CREATE OR ALTER PROCEDURE silver.load_data
as
BEGIN
	DECLARE @P_start_time DATETIME, @P_end_time DATETIME;
	DECLARE @start_time DATETIME, @end_time DATETIME;

	-- For silver.crm_cust_info

	SET @P_start_time = GETDATE();
	
	BEGIN TRY
		SET @start_time = GETDATE();

		PRINT 'Truncating the silver.crm_cust_info';
		TRUNCATE table silver.crm_cust_info;

		PRINT 'Inserting the data in silver.crm_cust_info';
		insert into silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		select
			cst_id,
			cst_key,
			TRIM(cst_firstname) as cst_firstname, -- Removing the unwanted spaces
			TRIM(cst_lastname) as cst_lastname, -- Removing the unwanted spaces
			case
				when UPPER(TRIM(cst_marital_status)) = 'S' then 'Single'
				when UPPER(TRIM(cst_marital_status)) = 'M' then 'Married'
				else 'n/a'
			end as cst_marital_status,
			case
				when UPPER(TRIM(cst_gndr)) = 'M' then 'Male'
				when UPPER(TRIM(cst_gndr)) = 'F' then 'Female'
				else 'n/a'
			end as cst_gndr,
			cst_create_date
		from (
			select
			*,
			row_number() over(partition by cst_id order by cst_create_date desc) as flag_last-- Removing the Duplicate by Taking the last inserted value for each cst_id(Primary key)
			from BRONZE.CRM_CUST_INFO
			where cst_id is not NULL 
			) t
		where flag_last = 1;

		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM SILVER.CRM_CUST_INFO;


		-- =================================================================================================================

		-- For silver.crm_prd_info

		SET @start_time = GETDATE();

		PRINT 'Truncating the silver.crm_prd_info';
		TRUNCATE table silver.crm_prd_info;

		PRINT 'Inserting the data in silver.crm_prd_info';
		insert into silver.crm_prd_info(
			prd_id,
			prd_key,
			cat_id,
			sls_prd_id,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		select
			prd_id,
			prd_key,
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
			SUBSTRING(prd_key,7,len(prd_key)) as sls_prd_id,
			TRIM(prd_nm) as prd_nm,
			coalesce (prd_cost,0) as prd_cost,
			case
				when prd_line = 'M' then 'Mountain'
				when prd_line = 'R' then 'Road'
				when prd_line = 'S' then 'Other Sales'
				when prd_line = 'T' then 'Touring'
				else 'n/a'
			end as prd_line,
			CAST(prd_start_dt as DATE) as prd_start_dt,
			CAST(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt) as DATE) as prd_end_dt
		from bronze.crm_prd_info;

		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM SILVER.CRM_PRD_INFO;

		/* ======================================================================================================================= */

		SET @start_time = GETDATE();

		PRINT 'Truncating the silver.crm_sales_info';
		TRUNCATE table silver.crm_sales_info;

		PRINT 'Inserting the data in silver.crm_sales_info';
		insert into silver.crm_sales_info(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_price,
			sls_quantity
		)
		select
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case	
				when sls_order_dt <= 0 or len(sls_order_dt) != 8 then NULL
				else cast(cast(sls_order_dt as varchar) as date)
			end as sls_order_dt,
			case	
				when sls_ship_dt <= 0 or len(sls_ship_dt) != 8 then NULL
				else cast(cast(sls_ship_dt as varchar) as date)
			end as sls_ship_dt,
			case	
				when sls_due_dt <= 0 or len(sls_due_dt) != 8 then NULL
				else cast(cast(sls_due_dt as varchar) as date)
			end as sls_due_dt,
			case
				when sls_sales <= 0 or sls_sales is null or sls_sales != abs(sls_price) * sls_quantity then abs(sls_price) * sls_quantity
				else sls_sales
			end as sls_sales,
			case 
				when sls_price <= 0 or sls_price is null then sls_sales / nullif(sls_quantity,0)
				else sls_price 
			end as sls_price,
			sls_quantity
		from bronze.crm_sales_info;

		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM SILVER.CRM_SALES_INFO;

		/*============================================================================================================================*/

		-- erp_cust_az12

		SET @start_time = GETDATE();

		PRINT 'Truncating the silver.erp_cust_az12';
		TRUNCATE table silver.erp_cust_az12;

		PRINT 'Inserting the data in silver.erp_cust_az12';
		insert into silver.erp_cust_az12(
			CID,
			BDATE,
			GEN
		)
		select
			case
				when cid like 'NAS%' then SUBSTRING(cid,4,LEN(cid))
				else cid
			end as cid,
			case 
				when bdate > getdate() then null
				else bdate
			end bdate,
			case 
				when UPPER(TRIM(gen)) in ('F','FEMALE') then 'Female'
				when UPPER(TRIM(gen)) in ('M','MALE') then 'Male'
				else 'n/a'
			end as gen
		from bronze.erp_cust_az12;

		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM SILVER.ERP_CUST_AZ12;


		/*==============================================================================================================================*/

		-- silver.erp_loc_a101

		SET @start_time = GETDATE();

		PRINT 'Truncating the silver.erp_loc_a101';
		TRUNCATE table silver.erp_loc_a101;

		PRINT 'Inserting the data in silver.erp_loc_a101';
		insert into silver.erp_loc_a101(
			cid,
			cntry
		)
		select
			REPLACE(cid,'-','') as cid,
			case
				when cntry = 'DE' then 'Germany'
				when cntry in ('USA','US') then 'United States'
				when cntry = '' or cntry is null then 'n/a'
				else cntry
			end as cntry
		from bronze.erp_loc_a101;

	
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM SILVER.ERP_LOC_A101;

		/* ============================================================================================================================= */

		-- erp_px_cat_g1v2

		SET @start_time = GETDATE();

		PRINT 'Truncating the silver.erp_px_cat_g1v2';
		TRUNCATE table silver.erp_px_cat_g1v2;

		PRINT 'Inserting the data in silver.erp_px_cat_g1v2';
		insert into silver.erp_px_cat_g1v2(
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		)
		select
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		from bronze.erp_px_cat_g1v2;

	
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM SILVER.ERP_PX_CAT_G1V2;
	END TRY
	BEGIN CATCH
		PRINT '===========================================';
		PRINT 'ERROR HAS OCCURED WHILE LOADING THE DATA IN BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '===========================================';
	END CATCH

	SET @P_end_time = GETDATE()
	PRINT 'LOAD DURATION FOR ALL TABLES ' + CAST( DATEDIFF(second, @P_start_time, @P_end_time) AS NVARCHAR) + ' second';

END
