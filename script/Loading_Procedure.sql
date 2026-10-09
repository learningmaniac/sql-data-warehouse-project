
/*
This is the script for Procedure of bulk data loading, we are first truncateing the tables than loading the data.
This script handle the error while loading the data, also the tell the duration of the loading the indivilual tables and whole batch.
Each Load is well formated by printing which table is loading.
*/

EXEC BRONZE.LOAD_BRONZE;

CREATE OR ALTER PROCEDURE BRONZE.LOAD_BRONZE AS
BEGIN
	DECLARE @P_start_time DATETIME, @P_end_time DATETIME;
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		SET @P_start_time = GETDATE()
		PRINT '===========================================';
		PRINT 'LOADING THE DATA IN BRONZE LAYER';
		PRINT '===========================================';

		PRINT '-------------------------------------------';
		PRINT 'LOADING CRM TABLES';
		PRINT '-------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: BRONZE.CRM_CUST_INFO';
		TRUNCATE TABLE BRONZE.CRM_CUST_INFO;
		PRINT '>> Inserting data into: BRONZE.CRM_CUST_INFO';
		BULK INSERT BRONZE.CRM_CUST_INFO
		FROM 'C:\Users\kumar\Desktop\Data warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM BRONZE.CRM_CUST_INFO;


		SET @start_time = GETDATE();
		PRINT '>> Truncating table: BRONZE.CRM_PRD_INFO';
		TRUNCATE TABLE BRONZE.CRM_PRD_INFO;
		PRINT '>> Inserting data into: BRONZE.CRM_PRD_INFO';
		BULK INSERT BRONZE.CRM_PRD_INFO
		FROM 'C:\Users\kumar\Desktop\Data warehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM BRONZE.CRM_PRD_INFO;

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: BRONZE.CRM_SALES_INFO';
		TRUNCATE TABLE BRONZE.CRM_SALES_INFO;
		PRINT '>> Inserting data into: BRONZE.CRM_SALES_INFO';
		BULK INSERT BRONZE.CRM_SALES_INFO
		FROM 'C:\Users\kumar\Desktop\Data warehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM BRONZE.CRM_SALES_INFO;

		PRINT '-------------------------------------------';
		PRINT 'LOADING ERP TABLES';
		PRINT '-------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: BRONZE.ERP_CUST_AZ12';
		TRUNCATE TABLE BRONZE.ERP_CUST_AZ12;
		PRINT '>> Inserting data into: BRONZE.ERP_CUST_AZ12';
		BULK INSERT BRONZE.ERP_CUST_AZ12
		FROM 'C:\Users\kumar\Desktop\Data warehouse\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM BRONZE.ERP_CUST_AZ12;

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: BRONZE.ERP_LOC_A101';
		TRUNCATE TABLE BRONZE.ERP_LOC_A101;
		PRINT '>> Inserting data into: BRONZE.ERP_LOC_A101';
		BULK INSERT BRONZE.ERP_LOC_A101
		FROM 'C:\Users\kumar\Desktop\Data warehouse\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM BRONZE.ERP_LOC_A101;

		SET @start_time = GETDATE();
		PRINT '>> Truncating table: BRONZE.ERP_PX_CAT_G1V2';
		TRUNCATE TABLE BRONZE.ERP_PX_CAT_G1V2;
		PRINT '>> Inserting data into: BRONZE.ERP_PX_CAT_G1V2';
		BULK INSERT BRONZE.ERP_PX_CAT_G1V2
		FROM 'C:\Users\kumar\Desktop\Data warehouse\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
		PRINT '--------------------';
		SELECT COUNT(*) FROM BRONZE.ERP_PX_CAT_G1V2;

		SET @P_end_time = GETDATE()
		PRINT 'LOAD DURATION FOR ALL TABLES ' + CAST( DATEDIFF(second, @P_start_time, @P_end_time) AS NVARCHAR) + ' second';
	END TRY
	BEGIN CATCH
		PRINT '===========================================';
		PRINT 'ERROR HAS OCCURED WHILE LOADING THE DATA IN BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '===========================================';
	END CATCH
END
