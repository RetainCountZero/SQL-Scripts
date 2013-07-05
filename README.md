# SQL-Scripts

This repository contains a collection of SQL- and PL/SQL-Scripts. The scripts consist of general SQL for administrative tasks and of BelVis3 EDM specific scripts to accomplish EDM application specific tasks.

The usage of these scripts is at your own risk. No responsiblities are taken by the creator of the scripts.

# List of scripts

## Generic Scripts

These scripts are of general interest for any Oracle instance and schema

### Generic-Comments.sql

Hints about how to add, remove, query comment information on tables and columns.

### Generic-Refresh-MViewlogs.sql

Rebuild all Materialized View Logs within a schema. This can be used when an ORA-12048 in conjunction with ORA-12034 error occurs.