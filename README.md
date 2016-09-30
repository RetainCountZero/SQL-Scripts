# SQL-Scripts

This repository contains a collection of SQL- and PL/SQL-Scripts. The scripts consist of general SQL for administrative tasks and of BelVis3 EDM specific scripts to accomplish EDM application specific tasks.

The usage of these scripts is at your own risk. No responsiblities are taken by the creator of the scripts.

# List of scripts

## Generic Scripts

These scripts are of general interest for any Oracle instance and schema

* *Generic-Comments.sql*

  Hints about how to add, remove, query comment information on tables and columns.

* *Generic-Data-Pump-info.sql*

  Hints about Data Pump
  * How to setup a directory objects
  * How to determine content of unknown dump files
  * How to use expdp and impdp utilities

* *Generic-Deprecated-Import-Export.sql*

  Examples of imp and exp usage. Deprecated, use Data Pump instead!

* *Generic-Refresh-MViewlogs.sql*

  Rebuild all Materialized View Logs within a schema. This can be used when an ORA-12048 in conjunction with ORA-12034 error occurs.

* *Generic-Bad-SQL.sql*

  A script from Taktum to identify sql statements with low performance.

## BelVis3 EDM Scripts

These scripts are geared towards tasks related to BelVis3 Energy Data Management (EDM).

* *BelVis-Check-MV-Owner.sql*

   BelVis uses materialized views based on data in the same schema. Sometimes the materialized view and its data source get mixed up. Run this script to determine if this problem matters on your system.

* *BelVis-Create-Read-Only-User.sql*

   Script to create a read-only user.  The scripts drops an existing read-only user.  Then it creates a new read-only user, grants access to tables and views of the source schema.  Finally it creates synonyms for all tables and views of the source schema for convenient access.

* *BelVis-Create-User.sql*

  How to create RESOURCE2, create a tablespace, create a user and grant sufficient privileges. After using this script a new 'Mandant' can be created in the 'BelVis Benutzerverwaltung'.
  Also a hint how to drop users no longer required.

* *BelVis-Script-on-all-BelVisAdm.sql*

  A very simple script which queries the BelVisAdm schema and creates a batch task file to run a predefined sql-script against all BelVis tenants.

* *BelVis-Statistics.sql*

  This scripts can be executed on any BelVis tenant to create new database statistics and set some statistics to recommended values. It is advises to run this script as a regular job. Use BelVis-Script-on-BelVisAdm.sql to create the job script.
  
* *BelVis-Systeminfo-Correction.sql*

  This scripts sets the values of the tablespace and indexspace. It can be applied after an import with the remap\_schema and remap\_tablespace options and before a run of dbmaintenance.exe.

* *BelVis-Summertime-2081-2099.sql*

  This script adds summertime entries to the table SOMMERZEIT.  A commit after running the script is required.
  
* *BelVis-Render-EnergyDistributionBookTemplatePFM.sql*

  This script renders a HTML text (via DBMS_OUTPUT) that consists of the book-templates defined in the function "Energiemengen Verteilen".

* *BelVis-Recreate-MV-Ext-Stat.sql*

  This script can be used to correct the ORA-12048 & ORA-00904 error combination.  The error is related to Oracle's extended statistics feature in 12.1.x.  This script avoids downtime in comparison to using DbMaintence.