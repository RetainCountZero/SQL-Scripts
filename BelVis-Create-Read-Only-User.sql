---- ----------------------------------------------------------------------
---- About:    Create a read-only user to acccess BelVis3 
---- Revision: 1
---- BelVis3:  3.19.x
---- ----------------------------------------------------------------------
--
-- N.B. This script should be executes in SQL*Plus
--
SET SERVEROUT ON
SET VERIFY OFF
CLEAR BUFFER
PROMPT
PROMPT ================================================
PROMPT Dieses Script legt einen Read-Only User zu einen 
PROMPT bestehenden BelVis Quell Schema an.
PROMPT ================================================
ACCEPT user_rw PROMPT 'Name des Quell BelVis Schemas:  '
ACCEPT user_ro PROMPT 'Name des Read-Only Schemas:     '
ACCEPT pwd_ro PROMPT 'Password des Read-Only Schemas: '

-- DELETE ANY OLD READ-ONLY SCHEMA OF THE SUPPLIED NAME.
PROMPT --==| Pruefe, ob ein Read-Only User namens &user_ro existiert.
DECLARE
  user_exists NUMBER;
BEGIN
  DBMS_OUTPUT.ENABLE(10000);
  SELECT COUNT(username) INTO user_exists
  FROM dba_users
  WHERE username = '&user_ro';
  IF user_exists = 1
  THEN
    DBMS_OUTPUT.PUT_LINE('--==| Read-Only User &user_ro wird geloescht.');
    EXECUTE IMMEDIATE 'DROP USER &user_ro CASCADE';
  END IF;
END;
/

-- CREATE THE NEW READ-ONLY USER
CREATE USER &user_ro
 PROFILE DEFAULT
 IDENTIFIED BY "&pwd_ro"
 DEFAULT TABLESPACE &user_rw
 TEMPORARY TABLESPACE temp
 QUOTA 0M ON &user_rw;

-- GRANT SELECT ON SELECTED OBJECTS OF THE SOURCE SCHEMA
-- CREATE SYNOMYNS OF SELECTED OBJECTS OF THE SOURCE SCHEMA
-- * Tables
-- * Views
VARIABLE user_rw VARCHAR2(30)
VARIABLE user_ro VARCHAR2(30)
BEGIN
  -- Transfer values of SQL*Plus variables to PL/SQL bind variables.
  :user_rw := '&user_rw';
  :user_ro := '&user_ro';
  -- Loop over all tables.
  DBMS_OUTPUT.PUT_LINE('--==| Zugriff auf Tables von &user_rw gestatten.');
  DBMS_OUTPUT.PUT_LINE('--==| Synonyme fuer Tables von &user_rw erstellen.');
  FOR i IN (SELECT table_name 
            FROM dba_tables 
            WHERE owner='&user_rw')
  LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || :user_rw || '.' || i.table_name || ' TO ' || :user_ro;
    EXECUTE IMMEDIATE 'CREATE SYNONYM ' || :user_ro || '.' || i.table_name || ' FOR ' || :user_rw || '.' || i.table_name;
  END LOOP;
  
  -- Loop over all views.
  DBMS_OUTPUT.PUT_LINE('--==| Zugriff auf Views von &user_rw gestatten.');
  DBMS_OUTPUT.PUT_LINE('--==| Synonyme fuer Views von &user_rw erstellen.');
  FOR i IN (SELECT view_name 
            FROM dba_views 
            WHERE owner='&user_rw')
  LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || :user_rw || '.' || i.view_name || ' TO ' || :user_ro;
    EXECUTE IMMEDIATE 'CREATE SYNONYM ' || :user_ro || '.' || i.view_name || ' FOR ' || :user_rw || '.' || i.view_name;
  END LOOP;
  
END;
/

-- Allow the new user to connect to the instance
GRANT CREATE SESSION to &user_ro;
-- Finally, unlock the new user.
ALTER USER &user_ro ACCOUNT UNLOCK;
-- Sayoonara
EXIT
