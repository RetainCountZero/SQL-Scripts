---- ----------------------------------------------------------------------
---- About:    Generate Statistics for BelVis Users
---- Revision: 1
---- ----------------------------------------------------------------------

DECLARE
  l_user        VARCHAR2(255);                                     -- current user
  l_date_format CONSTANT VARCHAR2(21) := 'DD:MM:YYYY hh24:mi:ss';  -- static date formatter
  l_date_start  TIMESTAMP;                                         -- used to compute total runtime
BEGIN
  SELECT SYSTIMESTAMP INTO l_date_start FROM dual;
  SELECT user INTO l_user FROM dual;
  DBMS_OUTPUT.ENABLE(200000);
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Generating statistics for user: ' || l_user);
  
  ---
  --- Generate statistics for user_indexes except TSD_% and TSC_% tables
  ---
  << index_without_tsd >>
  DECLARE
    CURSOR index_cur IS
      -- All non-locked indexes except TSD_% and TSC_%
      SELECT ui.index_name FROM user_indexes ui
      JOIN user_ind_statistics uis ON ui.index_name = uis.index_name
      WHERE uis.stattype_locked IS NULL
        AND ui.table_name NOT LIKE 'TSD_%'
        AND ui.table_name NOT LIKE 'TSC_%';
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start statistics for indexes except TSD_% and TSC_%');
    FOR index_rec IN index_cur LOOP
      DBMS_STATS.GATHER_INDEX_STATS(
        ownname => l_user,
        indname => index_rec.index_name,
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End statistics for indexes except TSD_% and TSC_%');
  END index_without_tsd;
  
  ---
  --- Generate statistics for user_indexes for TSD_% and TSC_% tables.
  --- Here we use a sample size of 1% because usually these indexes are huge.
  ---
  << index_only_tsd >>
  DECLARE
    CURSOR index_cur IS
      -- All non-locked indexes only TSD_% and TSC_%
      SELECT ui.index_name FROM user_indexes ui
      JOIN user_ind_statistics uis ON ui.index_name = uis.index_name
      WHERE uis.stattype_locked IS NULL
        AND ui.table_name LIKE 'TSD_%'
        AND ui.table_name LIKE 'TSC_%';
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start statistics for indexes only TSD_% and TSC_%');
    FOR index_rec IN index_cur LOOP
      DBMS_STATS.GATHER_INDEX_STATS(
        ownname => l_user,
        indname => index_rec.index_name,
        estimate_percent => 1);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End statistics for indexes only TSD_% and TSC_%');
  END index_only_tsd;

  ---
  --- Generate statistics for user_tables except TSD_% and TSC_% tables
  ---
  << table_without_tsd >>
  DECLARE
    CURSOR table_cur IS
      -- All non-locked tables except TSD_% and TSC_%
    SELECT ut.table_name FROM user_tables ut
      JOIN user_tab_statistics uts ON ut.table_name = uts.table_name
      WHERE uts.stattype_locked IS NULL
        AND ut.table_name NOT LIKE 'TSD_%'
        AND ut.table_name NOT LIKE 'TSC_%';
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start statistics for tables except TSD_% and TSC_%');
    FOR table_rec IN table_cur LOOP
      DBMS_STATS.GATHER_TABLE_STATS(
        ownname => l_user,
        tabname => table_rec.table_name,
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End statistics for tables except TSD_% and TSC_%');
  END table_without_tsd;
  
  ---
  --- Generate statistics for user_tables only TSD_% and TSC_% tables
  --- Here we use a sample size of 1% because usually these tables are huge.
  ---
  << table_for_tsd >>
  DECLARE
    CURSOR table_cur IS
      -- All non-locked tables except TSD_% and TSC_%
    SELECT ut.table_name FROM user_tables ut
      JOIN user_tab_statistics uts ON ut.table_name = uts.table_name
      WHERE uts.stattype_locked IS NULL
        AND ut.table_name LIKE 'TSD_%'
        AND ut.table_name LIKE 'TSC_%';
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start statistics for tables for TSD_% and TSC_%');
    FOR table_rec IN table_cur LOOP
      DBMS_STATS.GATHER_TABLE_STATS(
        ownname => l_user,
        tabname => table_rec.table_name,
        estimate_percent => 1);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End statistics for tables for TSD_% and TSC_%');
  END table_for_tsd;
  
  ---
  --- Set statistics for table ZRSTATUS
  ---
  << zrstatus_set_table_stats >>
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start set statistics for ZRSTATUS table');
    DBMS_STATS.SET_TABLE_STATS(
        ownname => l_user,
        tabname => 'ZRSTATUS',
        numrows => 100000,
        numblks => 2000,
        avgrlen => 54);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End set statistics for ZRSTATUS table');
  END zrstatus_set_table_stats;
  
  ---
  --- Set statistics for index IZRSTATUS01
  ---
  << zrstatus_set_index01_stats >>
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start set statistics for IZRSTATUS01 index');
    DBMS_STATS.SET_INDEX_STATS(
        ownname => l_user,
        indname => 'IZRSTATUS01',
        numrows => 100000,
        numlblks => 1000,
        numdist => 300);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End set statistics for IZRSTATUS01 index');
  END zrstatus_set_index01_stats;
  
  ---
  --- Set statistics for index IZRSTATUS02
  ---
  << zrstatus_set_index02_stats >>
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start set statistics for IZRSTATUS02 index');
    DBMS_STATS.SET_INDEX_STATS(
        ownname => l_user,
        indname => 'IZRSTATUS02',
        numrows => 100000,
        numlblks => 1000,
        numdist => 8);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End set statistics for IZRSTATUS02 index');
  END zrstatus_set_index02_stats;
  
  ---
  --- Set statistics for index IZRSTATUS03
  ---
  << zrstatus_set_index03_stats >>
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start set statistics for IZRSTATUS03 index');
    DBMS_STATS.SET_INDEX_STATS(
        ownname => l_user,
        indname => 'IZRSTATUS03',
        numrows => 100000,
        numlblks => 1000,
        numdist => 252);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End set statistics for IZRSTATUS03 index');
  END zrstatus_set_index03_stats;
  
  ---
  --- Set statistics for index IZRSTATUS04
  ---
  << zrstatus_set_index04_stats >>
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start set statistics for IZRSTATUS04 index');
    DBMS_STATS.SET_INDEX_STATS(
        ownname => l_user,
        indname => 'IZRSTATUS04',
        numrows => 100000,
        numlblks => 1000,
        numdist => 50000);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End set statistics for IZRSTATUS04 index');
  END zrstatus_set_index04_stats;
 
  ---
  --- Set statistics for index IZRSTATUS05
  ---
  << zrstatus_set_index05_stats >>
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start set statistics for IZRSTATUS05 index');
    DBMS_STATS.SET_INDEX_STATS(
        ownname => l_user,
        indname => 'IZRSTATUS05',
        numrows => 100000,
        numlblks => 1000,
        numdist => 5170);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End set statistics for IZRSTATUS05 index');
  END zrstatus_set_index05_stats;
 
  ---
  --- Set statistics for index IZRSTATUS06
  ---
  << zrstatus_set_index06_stats >>
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start set statistics for IZRSTATUS06 index');
    DBMS_STATS.SET_INDEX_STATS(
        ownname => l_user,
        indname => 'IZRSTATUS05',
        numrows => 100000,
        numlblks => 1000,
        numdist => 1560);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End set statistics for IZRSTATUS06 index');
  END zrstatus_set_index06_stats;
  
  ---
  --- Set statistics for index IZRSTATUS06
  ---
  << zrstatus_set_pk410_stats >>
  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Start set statistics for PK410');
    DBMS_STATS.SET_INDEX_STATS(
        ownname => l_user,
        indname => 'PK410',
        numrows => 100000,
        numlblks => 1000,
        numdist => 100000);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:]   End set statistics for PK410');
  END zrstatus_set_pk410_stats;
    
  -- Print total duration
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, l_date_format) || ' [INFO:] Total duration for user ' || l_user || ' was ' || 
                       TO_CHAR(SYSTIMESTAMP - l_date_start, l_date_format));
-- We are done. Sayoonara.
END;
/
