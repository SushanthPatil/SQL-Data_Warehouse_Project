/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

create or alter procedure bronze.load_bronze as
Begin
	declare @start_time Datetime, @end_time Datetime, @batch_start_time DATETIME, @batch_end_time DateTime;
	Begin Try
		set @batch_start_time = GETDATE();
		print '==============================================================================';
		print 'Loading Bronze Layer';
		print '==============================================================================';
		print '------------------------------------------------------------------------------';
		print 'Loading CRM Tables';
		print '------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		print '>> Truncating Table: bronze.crm_cust_info';
		Truncate table bronze.crm_cust_info;

		print'>> Inserting Data Into: bronze.crm_cust_info';
		BULK insert bronze.crm_cust_info
		from 'D:\Data Warehouse Project SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = GETDATE();
		print'<< Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar)+ ' seconds';
		print'>> ---------------------------------------------------------';
	
		SET @start_time = GETDATE();
		print '>> Truncating Table: bronze.crm_prd_info';
		Truncate table bronze.crm_prd_info;

		print'>> Inserting Data Into: bronze.crm_prd_info';
		BULK insert bronze.crm_prd_info
		from 'D:\Data Warehouse Project SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = GETDATE();
		print'<< Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar)+ ' seconds';
		print'>> ---------------------------------------------------------';

		SET @start_time = GETDATE();
		print '>> Truncating Table: bronze.crm_sales_details';
		Truncate table bronze.crm_sales_details;

		print'>> Inserting Data Into: bronze.crm_sales_details';
		BULK insert bronze.crm_sales_details
		from 'D:\Data Warehouse Project SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = GETDATE();
		print'<< Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar)+ ' seconds';
		print'>> ---------------------------------------------------------';

		print '------------------------------------------------------------------------------';
		print 'Loading ERP Tables';
		print '------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_cust_az12';
		Truncate table bronze.erp_cust_az12;

		print'>> Inserting Data Into: bronze.erp_cust_az12';
		BULK insert bronze.erp_cust_az12
		from 'D:\Data Warehouse Project SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = GETDATE();
		print'<< Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar)+ ' seconds';
		print'>> ---------------------------------------------------------';

		SET @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_loc_a101';
		Truncate table bronze.erp_loc_a101;

		print'>> Inserting Data Into: bronze.erp_loc_a101';
		BULK insert bronze.erp_loc_a101
		from 'D:\Data Warehouse Project SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = GETDATE();
		print'<< Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar)+ ' seconds';
		print'>> ---------------------------------------------------------';

		SET @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_PX_CAT_G1V2';
		Truncate table bronze.erp_PX_CAT_G1V2;

		print'>> Inserting Data Into: bronze.erp_PX_CAT_G1V2';
		BULK insert bronze.erp_PX_CAT_G1V2
		from 'D:\Data Warehouse Project SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock 
		);
		set @end_time = GETDATE();
		print'<< Load Duration: ' + cast(Datediff(second, @start_time, @end_time) as nvarchar)+ ' seconds';
		print'>> ---------------------------------------------------------';

		set @batch_end_time = GETDATE();
		print'=================================================================================================';
		print' Loading Bronze Layer is Completed';
		print'    -Total Load Duration: ' + cast(Datediff(second, @batch_start_time, @batch_end_time) as nvarchar)+ ' seconds';
		print'=================================================================================================';

	end try
	begin catch
		print'============================================================================';
		print 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + Error_message();
		print 'Error Message' + cast (error_number() as nvarchar);
		print 'Error Message' + cast(error_state() as nvarchar);
		print'============================================================================';
	end Catch
end


