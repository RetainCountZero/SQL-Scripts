---- ----------------------------------------------------------------------
---- About:    Check if assignment of MV is wrong
---- Revision: 1
---  BelVis3:  3.16.x
---- ----------------------------------------------------------------------

--- Verify owner != master_owner
--- If this select statement returns a result
--- then run dbmaintenance on all listed users.
SELECT owner, master_owner, name as MVIEWNAME, master as MASTERNAME 
FROM dba_mview_refresh_times 
WHERE owner != master_owner;