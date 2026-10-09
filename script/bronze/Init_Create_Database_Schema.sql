

/* =========================================================================
This script is for CREATE DATABASE AND SCHEMAS, If are checking first if the database exist or not if it do we droping it and creating new
one.

Warning 
Running this script will result in loss of data if the database already exsit in server. Be carefull Before Running it.
*/

use master;
GO;

IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'DATAWAREHOUSE')
BEGIN
    DROP DATABASE DATAWAREHOUSE;
END
GO;

CREATE DATABASE DATAWAREHOUSE;
GO;

CREATE SCHEMA BRONZE;
GO;

CREATE SCHEMA SILVER;
GO;

CREATE SCHEMA GOLD;
GO;
