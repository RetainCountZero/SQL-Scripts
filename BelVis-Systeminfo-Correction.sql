---- ----------------------------------------------------------------------
---- About:    Update systeminfo table with used tablespace and indexspace
---- Revision: 1
---  BelVis3:  3.16.x
---- ----------------------------------------------------------------------

DECLARE
  cm_tablespacename           VARCHAR2(64);
  cm_more_than_one_tablespace EXCEPTION;

BEGIN

  -- do we have exactly one tablespace for this user?
  DECLARE
    cm_count                  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO cm_count FROM user_tablespaces;
    IF (cm_count != 1) THEN
      RAISE cm_more_than_one_tablespace;
    END IF;
  END;

  -- Update systeminfo
  SELECT tablespace_name INTO cm_tablespacename FROM user_tablespaces;
  DBMS_OUTPUT.PUT_LINE('Tablespace name is ' || cm_tablespacename || '.');
  UPDATE systeminfo SET info_s = cm_tablespacename WHERE name_s IN ('TblSpace', 'IdxSpace');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Tablespace and Indexspace have been updated to ' || cm_tablespacename || '.');

-- Exception handling
EXCEPTION
  WHEN cm_more_than_one_tablespace
  THEN
    DBMS_OUTPUT.ENABLE(20000);
    DBMS_OUTPUT.PUT_LINE('There''s more than one tablespace associated to this user.' || chr(10) 
                      || 'I don''t know what to write into table systeminfo.');
  WHEN OTHERS 
  THEN
    RAISE;
    
END;
/