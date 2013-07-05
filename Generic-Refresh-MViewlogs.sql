---- ----------------------------------------------------------------------
---- About:    Refresh Materialized View Logs
---- Revision: 1
---- ----------------------------------------------------------------------

---
--- Hint: 'C' = Complete, 'F' = Fast
--- Hint: Depending on the amount and size of MV this creates some load
---
DECLARE
  CURSOR mview_cur IS
    SELECT mview_name FROM user_mviews;
BEGIN
  dbms_output.enable(20000);
  -- Loop over all materialized views
  FOR mview_rec IN mview_cur
  LOOP
    dbms_output.put_line('Refreshing Materialized View ' 
                      || mview_rec.mview_name || '.');
    dbms_snapshot.refresh(mview_rec.mview_name,'C'); 
  END LOOP;
END;
/