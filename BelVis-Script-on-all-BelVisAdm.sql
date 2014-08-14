---- ----------------------------------------------------------------------
---- About:    General scripts execution over all belvisadm 'mandanten'
---- Revision: 1
---- ----------------------------------------------------------------------

--- Usage
--- Run this script on the belvisadm user
--- e.g. C:\>sqlplus belvisadm/12345@belvisdb @BelVis-Script-on-all-BelVisadm.sql
--- This creates the file d:\BelVis-Stats.cmd which can be run via tasks.

--- Adapt the line 'SPOOL ...'
--- Adapt the line 'SELECT ...'

SET PAGESIZE 0
SET LINESIZE 150
SET FEEDBACK OFF
SPOOL D:\BelVis-Stats.cmd
SELECT 'sqlplus ' || user_s || '/' || pwd_s || '@' || server_s || ' @D:\BelVis-Statistics.sql' 
FROM adm_mandant ORDER BY user_s;
SPOOL OFF
EXIT
