---- ----------------------------------------------------------------------
---- About:    Several examples how to create and query comments
---- Revision: 1
---- ----------------------------------------------------------------------

---
--- Adding and removing comments
---
-- Add a comment to a table
COMMENT ON TABLE stationbase IS 'Alle Instanzen in BelVis';
-- Remove a comment from a table
COMMENT ON TABLE stationbase IS '';
-- Add a comment to a column of a table
COMMENT ON COLUMN stationbase.mstnr_s IS 'Meist verwendet als Kürzel einer Instanz in BelVis';
-- Remove a comment from a column of a table
COMMENT ON COLUMN Employee.First_Name IS '';

---
--- Querying for comments
---
-- Query comments regarding a whole table
SELECT * FROM user_tab_comments WHERE comments IS NOT NULL;
SELECT * FROM dba_tab_comments WHERE comments IS NOT NULL;
SELECT * FROM all_tab_comments WHERE comments IS NOT NULL;
-- Query comments regarding a single column
SELECT * FROM user_col_comments WHERE comments IS NOT NULL ORDER BY table_name;
SELECT * FROM dba_col_comments WHERE comments IS NOT NULL;
SELECT * FROM all_col_comments WHERE comments IS NOT NULL;
