---- ----------------------------------------------------------------------
---- About:    Check and modify the "Entstehungsbeginn" in BelVis PFM
---- Revision: 1
---- BelVis3:  3.23.x
---- ----------------------------------------------------------------------

-- Review existing entry.  If no row is returned, 
-- run the next two INSERT statementes.  Otherwise
-- just run the UPDATE statement.
-- Don't forget to COMMIT.
SELECT ie.ident,
  ie.section_l, ise.sectionname_s,
  ie.label_s,
  ie.value_s,
  ie.computerid_l,
  ie.userid_l
FROM inientry ie
JOIN inisection ise ON ise.ident = ie.section_l
WHERE ise.sectionname_s = 'EXTRAS'
  AND ie.label_s = 'ENTSTEHUNG'
ORDER by ise.sectionname_s;

-- Usually this entry exists
INSERT INTO inisection
(ident, sectionname_s)
SELECT seq_appmain.nextval, 'EXTRAS' FROM dual
WHERE NOT EXISTS (SELECT *
                  FROM inisection
                  WHERE sectionname_s = 'EXTRAS');

-- This should exist, too
INSERT INTO inientry
(ident, section_l, label_s, value_s, computerid_l, userid_l)
SELECT 
  seq_7602.nextval, 
  ident, 
  'EXTRAS', 
  '01.01.2010 00:00:00',
  NULL,
  NULL
FROM inisection
WHERE sectionname_s = 'EXTRAS'
  AND NOT EXISTS (SELECT *
                  FROM inientry
                  WHERE label_s = 'ENTSTEHUNG');

-- In most cases this should be sufficient to change the "Entstehungbeginn".
UPDATE inientry 
SET value_s = '01.01.2010 00:00:00'
WHERE label_s = 'ENTSTEHUNG';
-- Are you sure?
COMMIT;