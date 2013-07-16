---- ----------------------------------------------------------------------
---- About:    Command examples of imp and exp utilities
---- Revision: 1
---- ----------------------------------------------------------------------

---
--- Important: IMP and EXP are deprecated
--- Important: This is only for reference. Use Data Pump instead.

-- imp user/pwd@instance file=dumpfile.dmp log=dumpfile.imp.log fromuser=old_user touser=new_user ignore=y commit=y buffer=10000000 feedback=10000
-- exp user/pwd@instance file=dumpfile.dmp log=dumpfile.exp.log grants=n compress=n statistics=none feedback=10000 buffer=10000000