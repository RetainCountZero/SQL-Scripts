---- ----------------------------------------------------------------------
---- About:    Drop certain Extended Stats and recreate related 
----           Materialized Views
----           Use this script if you encounter the ORA-12048 & ORA-00904
---- Revision: 1
---- BelVis3:  3.23.x
---- ----------------------------------------------------------------------


---- Remove Extended Stats
BEGIN
  FOR i IN (SELECT TABLE_NAME, EXTENSION 
            FROM USER_STAT_EXTENSIONS 
            WHERE TABLE_NAME IN ('MANAGER', 
                                 'WK_VORDEFKA'))
   LOOP
     DBMS_STATS.DROP_EXTENDED_STATS (ownname   => USER, 
                                     tabname   => i.TABLE_NAME,
                                     extension => i.EXTENSION);
  END LOOP;
END;
/

-- MV_MANAGER_ANREDE
DROP MATERIALIZED VIEW MV_MANAGER_ANREDE;
CREATE MATERIALIZED VIEW MV_MANAGER_ANREDE
BUILD IMMEDIATE
REFRESH FAST ON COMMIT 
AS SELECT AdrAnr_s, COUNT(*) AS anzahl 
   FROM manager 
   GROUP BY AdrAnr_s;

-- MV_MANAGER_ORT
DROP MATERIALIZED VIEW MV_MANAGER_ORT;
CREATE MATERIALIZED VIEW MV_MANAGER_ORT
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS SELECT adrort_s, COUNT(*) AS anzahl 
   FROM manager 
   GROUP BY adrort_s;

-- MV_MANAGER_PLZ
DROP MATERIALIZED VIEW MV_MANAGER_PLZ;
CREATE MATERIALIZED VIEW MV_MANAGER_PLZ
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS SELECT adrplz_s, COUNT(*) AS anzahl 
   FROM manager 
   GROUP BY adrplz_s;

-- MV_WK_VORDEFKA_ORT
DROP MATERIALIZED VIEW MV_WK_VORDEFKA_ORT;
CREATE MATERIALIZED VIEW MV_WK_VORDEFKA_ORT
BUILD IMMEDIATE 
REFRESH FAST ON COMMIT
AS SELECT stadt_s, COUNT(*) AS anzahl 
   FROM wk_vordefka 
   GROUP BY stadt_s;

-- MV_WK_VORDEFKA_PLZ
DROP MATERIALIZED VIEW MV_WK_VORDEFKA_PLZ;
CREATE MATERIALIZED VIEW MV_WK_VORDEFKA_PLZ
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS SELECT vonplz_l, COUNT(*) AS anzahl 
   FROM wk_vordefka 
   GROUP BY vonplz_l;