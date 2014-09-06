---- ----------------------------------------------------------------------
---- About:    Parse v$sql to identify low performance SQL statememts
---- Revision: 1
---- ----------------------------------------------------------------------

--- The following command shows for SQL statements from the SQL-Cache
--- * how often they are executed (Executions)
--- * how many block access are required for their execution (Gets)
--- * Ratio of gets to exec
--- * Hit ratio
--- A hit ratio below 70% indicates a read access without any index.
--- Adding an index for these statements might be considered.
--- N.B.: This statements works only the the SQL-Cache.  Run it more
---       than once to get a better picture of what is going on.
---
--- The filter "buffer_gets > 1000" limits the number of results.

SELECT 
  to_char(executions, '999G999G990') "Executions",
  to_char(buffer_gets, '999G999G990') "Gets",
  to_char(buffer_gets/greatest(nvl(executions,1),1), '999G999G990') "Gets / Exec",
  to_char (round(100*(1-(disk_reads/greatest(nvl(buffer_gets,1),1))),2), '990D00') "Hit Ratio",
  sql_text
FROM v$sql
WHERE buffer_gets > 1000
ORDER BY buffer_gets DESC;