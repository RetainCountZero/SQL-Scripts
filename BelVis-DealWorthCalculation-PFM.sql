---- ----------------------------------------------------------------------
---- About:    Create a DBMS-Job to calcute Deal Worth in PFMPOWER/PFMGAS
---- Revision: 1
---- BelVis3:  3.23.x
---- ----------------------------------------------------------------------


-- Remove Scheduled task
BEGIN
    DBMS_SCHEDULER.DROP_JOB(job_name => '"GESCHAEFTSWERT_BERECHNEN_30MIN"',
                                defer => false,
                                force => false);
END;
/

-- Create scheduled task
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"GESCHAEFTSWERT_BERECHNEN_30MIN"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
  FOR i IN (SELECT ident FROM v_sd_deal vd
            WHERE vd.pricevaluelist_l IS NOT NULL
            AND vd.modificationdate_ts > TO_DATE(''01.01.2016'',''DD.MM.YYYY''))
  LOOP
    calc_dealworth_by_pricevl(1,i.ident);
  END LOOP;
END;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2017-02-17 17:45:00.000000000 EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=30;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Geschaeftswert alle 30 Minuten berechnen');
    /* Works only with Oracle 12c
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"GESCHAEFTSWERT_BERECHNEN_30MIN"', 
             attribute => 'store_output', value => TRUE);
    */
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"GESCHAEFTSWERT_BERECHNEN_30MIN"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
    
    DBMS_SCHEDULER.enable(
             name => '"GESCHAEFTSWERT_BERECHNEN_30MIN"');
END;
/