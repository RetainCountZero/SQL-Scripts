# SQL-Scripts

This repository contains a collection of SQL- and PL/SQL-Scripts. The scripts consist of general SQL for administrative tasks and of BelVis3 EDM specific scripts to accomplish EDM application specific tasks.

The usage of these scripts is at your own risk. No responsiblities are taken by the creator of the scripts.

# List of scripts

## Generic Scripts

These scripts are of general interest for any Oracle instance and schema

* *Generic-Comments.sql*

  Hints about how to add, remove, query comment information on tables and columns.

* *Generic-Refresh-MViewlogs.sql*

  Rebuild all Materialized View Logs within a schema. This can be used when an ORA-12048 in conjunction with ORA-12034 error occurs.

## BelVis3 EDM Scripts

These scripts are geared towards tasks related to BelVis3 Energy Data Management (EDM).

* BelVis-Create-User.sql

  How to create RESOURCE2, create a tablespace, create a user and grant sufficient privileges. After using this script a new 'Mandant' can be created in the 'BelVis Benutzerverwaltung'.
  Also a hint how to drop users no longer required.
  
* BelVis-Systeminfo-Correction.sql

  This scripts sets the values of the tablespace and indexspace. It can be applied after an import with the remap\_schema and remap\_tablespace options and before a run of dbmaintenance.exe.
  