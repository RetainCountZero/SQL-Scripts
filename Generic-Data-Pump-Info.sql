---- ----------------------------------------------------------------------
---- About:    Collection of commands and hints related to Data Pump
---- Revision: 1
---- ----------------------------------------------------------------------

---
--- Create a directory object and grant permissions
---
CREATE DIRECTORY DataPump AS 'D:\Dumps';
GRANT READ, WRITE ON DIRECTORY DataPump TO RESOURCE2;
SELECT DIRECTORY_NAME, DIRECTORY_PATH FROM DBA_DIRECTORIES;

---
--- Check perssions of directories for the current user
---
SELECT * FROM datapump_dir_objs;

---
--- A method to look at the master table before the actual import
---
-- Perform a dummy import by using the SQLFILE argument like this
-- impdp system/***@belvis316 directory=data_pump_dir dumpfile=mydumpfile.dmp sqlfile=sql.txt nologfile=y keep_master=y
-- Take note of the name of the master table (Master table "SYSTEM"."SYS_SQL_FILE_FULL_01" successfully loaded/unloaded)
-- Check the data in the master table
SELECT original_object_schema, original_object_name FROM sys_sql_file_full_01 WHERE original_object_schema IS NOT NULL;
SELECT DISTINCT(original_object_schema) FROM sys_sql_file_full_01;
-- drop master table afterwards
DROP TABLE system.sys_sql_file_full_01 CASCADE CONSTRAINTS PURGE;

---
--- Example call of impdp utility to import a dump file with lots of excluded objects
--- If an object in not in the dump it can't be excluded. This causes an error.
---
-- impdp user_new/pwd@alias DIRECTORY=data_pump_dir SCHEMAS=user_old DUMPFILE=<filename_>%U.dpdmp LOGFILE=user_new.impdp.log REMAP_SCHEMA=user_old:user_new REMAP_TABLESPACE=user_old:user_new TRANSFORM=segment_attributes:N,oid:N TABLE_EXISTS_ACTION=append EXCLUDE=ALTER_FUNCTION,ALTER_PROCEDURE,ALTER_PACKAGE_SPEC,DEFAULT_ROLE,JOB,POST_TABLE_ACTION,REFRESH_GROUP,ROLE_GRANT,TABLESPACE_QUOTA,TYPE_SPEC,USER:\"=\'user_old\'\" 

---
--- Example call of expdp utility to export a dump file without materialized views and mv logs
---
-- expdp schema_name/pwd@alias DIRECTOTY=data_pump_dir SCHEMAS=schema_name DUMPFILE=data_pump_dir:schema_name.dpdmp LOGFILE=data_pump_dir:schema_name.expdp.log EXCLUDE=MATERIALIZED_VIEW,MATERIALIZED_VIEW_LOG
