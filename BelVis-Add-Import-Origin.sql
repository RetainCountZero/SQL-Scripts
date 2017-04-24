---- ----------------------------------------------------------------------
---- About:    Add the origin 'Import' or 'Versionserstellung bei Import'
----           to timeseries identified by their data exchange number.
---- Revision: 1
---- BelVis3:  3.24.x
---- ----------------------------------------------------------------------

---- ----------------------------------------------------------------------
---- Usage and hints
----
---- Example calls of the procedure:
----
---- CM_INSERT_ORIGIN('abc', 'Import', TO_DATE('01.01.2000 00:00:00', 'DD.MM.YYYY HH24:MI:SS'), TRUE);
---- CM_INSERT_ORIGIN('abc', 'Versionserstellung bei Import');
---- CM_INSERT_ORIGIN('abc', deactivate_existing_origin => FALSE);
----
---- See example usage at the bottom of this file.
----
---- First argument must be supplied.  It is a string of the data exchange
---- number in BelVis3.
----
---- Second argument defaults to 'Import'. If supplied it must be one of
----   'Import'
----   'Versionserstellung bei Import'
----
---- Third argument defines the valid from date of the origin. It defaults
---- to the timestamp 01.01.2000 00:00:00.
----
---- Fourth argument indicates if an existing active origin should be set
---- inactive.  It defaults to TRUE.  Be careful, repeated execution of
---- the procedure will add a new entry with each execution.
---- ----------------------------------------------------------------------

-- Anonymous PL/SQL block
DECLARE
  -- Anonymous procedure within this block
  PROCEDURE cm_insert_origin (exchange_number IN VARCHAR2, 
                              import_origin_type IN VARCHAR2 DEFAULT 'Import', 
                              valid_from IN DATE DEFAULT TO_DATE('01.01.2000 00:00:00', 'DD.MM.YYYY HH24:MI:SS'), 
                              deactivate_existing_origin IN BOOLEAN DEFAULT TRUE)
  IS
    invalid_import_origin_type EXCEPTION;
    origin_ident NUMBER;
    TYPE origin_info IS RECORD (mno_ident NUMBER, o_ident NUMBER);
    active_origin_info origin_info;
  BEGIN
    SELECT seq_appmain.nextval INTO origin_ident FROM dual;
    -- check if mnorigin already has an active origin at given date
    IF deactivate_existing_origin
    THEN
      SELECT mno.ident, mno.origin_l INTO active_origin_info
      FROM mnorigin mno
      JOIN ts_valuelist tsv ON tsv.ident = mno.valuelist_l
      WHERE tsv.wiski_danr_s = exchange_number
        AND mno.aktiv_si = 1
        AND mno.startvalid_ts = valid_from;
      IF active_origin_info.mno_ident > 0 THEN
        UPDATE mnorigin SET aktiv_si = 0 WHERE ident = active_origin_info.mno_ident;
        UPDATE origin SET aktiv_si = 0 WHERE ident = active_origin_info.o_ident;
      END IF;
    END IF;  
    -- Modify table ORIGIN
    IF import_origin_type = 'Import'
    THEN
      INSERT INTO origin (ident,            -- seq_appmain.nextval
                          name_s,           -- 'Import'
                          table_l,          -- 1207
                          aktiv_si,         -- 1
                          remark_l,         -- -1
                          startvalid_ts,    -- TO_DATE('01.01.2000 00:00:00', 'DD.MM.YYYY HH24:MI:SS')
                          edittsallowed_si, -- 0
                          copyallowed_si,   -- 1
                          markdeps_si,      -- 1
                          objectid_l)       -- seq_1200_objid.nextval
      VALUES (origin_ident, 'Import', 1207, 1, -1, valid_from, 0, 1, 1, seq_1200_objid.nextval);
    ELSIF import_origin_type = 'Versionserstellung bei Import'
    THEN
      INSERT INTO origin (ident,            -- seq_appmain.nextval
                          name_s,           -- 'Import'
                          table_l,          -- 1207
                          aktiv_si,         -- 1
                          remark_l,         -- -1
                          startvalid_ts,    -- TO_DATE('01.01.2000 00:00:00', 'DD.MM.YYYY HH24:MI:SS')
                          edittsallowed_si, -- 0
                          copyallowed_si,   -- 1
                          markdeps_si,      -- 1
                          objectid_l)       -- seq_1200_objid.nextval
      VALUES (origin_ident, 'Versionserstellung bei Import', 8102, 1, -1, valid_from, 0, 1, 1, seq_1200_objid.nextval);
    ELSE
      RAISE_APPLICATION_ERROR(-20100, 
           'import_origin_type must be either ''Import'' or ''Versionserstellung bei Import''');
    END IF;
    -- Modify table MNORIGIN
    INSERT INTO mnorigin (ident,         -- seq_appmain.nextval
                          valuelist_l,   -- aus ts_valuelist, 
                          origin_l,      -- ident aus vorherigen Statement, 
                          aktiv_si,      -- 1, 
                          startvalid_ts) -- gleicher Zeitpunkt wie vorheriges Statement
    VALUES (seq_appmain.nextval,
            (SELECT ident FROM ts_valuelist WHERE wiski_danr_s = exchange_number),
            origin_ident, 1, valid_from);
  END cm_insert_origin;
  
BEGIN
  -- This needs to be adapted to another DANR, preferably some LOOP construct.
  -- CM_INSERT_ORIGIN('abc', 'Import', TO_DATE('01.01.2000 00:00:00', 'DD.MM.YYYY HH24:MI:SS'), TRUE);
  -- CM_INSERT_ORIGIN('abc', deactivate_existing_origin => TRUE);
  CM_INSERT_ORIGIN('abc', 'Versionserstellung bei Import');
END;
/
-- Do not forget to COMMIT your changes!
-- COMMIT;