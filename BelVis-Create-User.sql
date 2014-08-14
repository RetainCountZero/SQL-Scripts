---- ----------------------------------------------------------------------
---- About:    Prepare an oracle user for use with BelVis3 EDM
---- Revision: 1
---  BelVis3:  3.16.x
---- ----------------------------------------------------------------------

---
--- Once: Loosen password error restrictions
---
ALTER PROFILE "DEFAULT" LIMIT PASSWORD_LIFE_TIME UNLIMITED PASSWORD_GRACE_TIME UNLIMITED FAILED_LOGIN_ATTEMPTS UNLIMITED;
---
--- Once: Generate Role RESOURCE2
---
CREATE ROLE resource2 NOT IDENTIFIED;
GRANT ALTER SESSION TO resource2;
GRANT CREATE CLUSTER TO resource2;
GRANT CREATE INDEXTYPE TO resource2;
GRANT CREATE JOB TO resource2;
GRANT CREATE MATERIALIZED VIEW TO resource2;
GRANT CREATE OPERATOR TO resource2;
GRANT CREATE PROCEDURE TO resource2;
GRANT CREATE SEQUENCE TO resource2;
GRANT CREATE SYNONYM TO resource2;
GRANT CREATE TABLE TO resource2;
GRANT CREATE TRIGGER TO resource2;
GRANT CREATE TYPE TO resource2;
GRANT CREATE VIEW TO resource2;
-- require SYS privileges for successful execution:
GRANT SELECT ON DBA_MVIEW_REFRESH_TIMES TO resource2;
GRANT SELECT ON V_$SESSION TO resource2;
---
--- For BelVis3 tablespace name und user name should be identical.
--- In case of ASM based storage use:
--- CREATE TABLESPACE stromvertrieb;
--- In case of file system based storage use:
---
CREATE SMALLFILE TABLESPACE stromvertrieb DATAFILE 'D:\oradata\instanceName\STROMVERTRIEB.DBF' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 8G LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;
CREATE USER stromvertrieb PROFILE "DEFAULT" IDENTIFIED BY "password" DEFAULT TABLESPACE stromvertrieb QUOTA UNLIMITED ON stromvertrieb ACCOUNT UNLOCK;
GRANT connect TO stromvertrieb;
GRANT resource2 TO stromvertrieb;
---
--- In case of belvisadm schema 
--- GRANT select_catalog_role TO belvisadm;
---
--- Dropping users and tablespaces
--- Did you make a backup?
---
DROP USER stromvertrieb CASCADE;
DROP TABLESPACE stromvertrieb INCLUDING CONTENTS AND DATAFILES;
