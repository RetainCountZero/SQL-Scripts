---- ----------------------------------------------------------------------
---- About:    Check for possible reasons of ORA-04043 TYPE errors
---- Revision: 1
---- BelVis3:  3.20.x
---- ----------------------------------------------------------------------

--- Step 1: Check if this script returns any rows with Amount > 1
---
WITH t1 AS (
  SELECT DISTINCT
    regexp_substr(object_name, '(.{9}_)([a-zA-Z0-9]+)(.+)', 1, 1, 'i', 2) "SYS_PLSQL", 
    owner,
    object_type
  FROM all_objects 
  WHERE object_name LIKE 'SYS_PLSQL_%'
  ORDER by 1)
SELECT 
  COUNT(t1.sys_plsql) AS "Amount",
  'SYS_PLSQL_' || t1.sys_plsql || '_' AS "Type-String-Beginning-With"
FROM t1
GROUP BY t1.sys_plsql
ORDER BY COUNT(t1.sys_plsql) DESC;
---
--- Step 2: Review the full data / perhaps adapt the WHERE clause
---
SELECT DISTINCT
  regexp_substr(object_name, '(.{9}_)([a-zA-Z0-9]+)(.+)', 1, 1, 'i', 2) "SYS_PLSQL", 
  owner,
  object_type
FROM all_objects 
WHERE object_name LIKE 'SYS_PLSQL_%'
ORDER by 1;