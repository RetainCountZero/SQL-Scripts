---- ----------------------------------------------------------------------
---- About:    Log all schema DDL events into a table called DDL_LOG
---- Revision: 1
---- ----------------------------------------------------------------------

---
--- Create a table that holds all DDL events
---
CREATE TABLE ddl_log (user_name     VARCHAR2(30),
                      ddl_date      DATE,
                      ddl_type      VARCHAR2(30),
                      object_type   VARCHAR2(18),
                      owner         VARCHAR2(30),
                      object_name   VARCHAR2(128));

---
--- Create a trigger that logs all DLL events into table ddl_log                      
---
CREATE OR REPLACE TRIGGER ddl_trig
AFTER DDL
ON SCHEMA
BEGIN
  INSERT INTO ddl_log (user_name, 
                       ddl_date, 
                       ddl_type,
                       object_type, 
                       owner, 
                       object_name)
  VALUES (ora_login_user, 
          SYSDATE, 
          ora_sysevent,
          ora_dict_obj_type, 
          ora_dict_obj_owner,
          ora_dict_obj_name);
END ddl_trig;
/