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

* *Generic-DDL-Log.sql*

  Creates a table within the current schema to store all DDL events and generates a matching trigger to log all DDL events into a table called DDL_LOG.

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

  A very simple script which queries the BelVisAdm schema and creates a batch task file to run a predefined sql-script against all BelVis tenants.  Works only up to BelVis 3.22.x

* *BelVis-Statistics.sql*

  This scripts can be executed on any BelVis tenant to create new database statistics and set some statistics to recommended values. It is advised to run this script as a regular job. Use BelVis-Script-on-BelVisAdm.sql to create the job script.
  
* *BelVis-Systeminfo-Correction.sql*

  This scripts sets the values of the tablespace and indexspace. It can be applied after an import with the remap\_schema and remap\_tablespace options and before a run of dbmaintenance.exe.

* *BelVis-Summertime-2081-2099.sql*

  This script adds summertime entries to the table SOMMERZEIT.  A commit after running the script is required.

* *BelVis-Recreate-MV-Ext-Stat.sql*

  This script can be used to correct the ORA-12048 & ORA-00904 error combination.  The error is related to Oracle's extended statistics feature in 12.1.x.  This script avoids downtime in comparison to using DbMaintence.

* *BelVis Entstehungsbeginn-PFM.sql*

  This scripts modifies the "Entstehungsbeginn" in BelVis PFM.  Since there is no GUI option to modify the setting, this setting is changed in the database directly.  Review Script before executing and adapt the desired date.  With new tenants there may be not entry at all in the database - for this case two conditional insert statements are included in the script.  This script works on BelVis EDM and PFM, however in EDM using the GUI is recommended.

* *BelVis-Add-Import-Origin.sql*

  This script adds the origin 'Import' or 'Versionserstellung bei Import' to existing time series.  Please read the comment in the script before using it.

## BelVis3 PFM Scripts
  
* *BelVis-Render-EnergyDistributionBookTemplatePFM.sql*

  This script renders a HTML text (via DBMS_OUTPUT) that consists of the book-templates defined in the function "Energiemengen Verteilen".

* *BelVis-DealWorthCalculation-PFM.sql*

  This script creates a DBMS-Job which runs the procedure CALC\_DEALWORTH\_BY\_PRICEVL in a fixed repetition cycle.  This default cycle is set to 30 minutes and all deals from 2016-01-01, however this can be modified in the script.  The script deletes the DBMS-Job first.  If you want to keep the existing job, please execute only the create section of the script.
  