---- ----------------------------------------------------------------------
---- About:    Parse v$sql to identify low performance SQL statememts
---- Revision: 1
---- ----------------------------------------------------------------------

--- Der folgende Befehl zeigt für die SQL-Befehle, die sich im SQL-Cache 
--- befinden, wie oft sie ausgeführt wurden und wieviele Blockzugriffe sie zur 
--- Abarbeitung benötigten. Ausserdem wird die Trefferquote des Befehls im 
--- Datencache angezeigt. Damit lassen sich sehr schnell "schlecht optimierte" 
--- SQL-Befehle herausfinden. Trefferquoten kleiner 70% deuten regelmäßig darauf 
--- hin, dass eine Tabelle vollständig ohne Index-Zugriffe gelesen wird. Ggf. 
--- ist ein weiterer Index hinzuzufügen, um den Befehl zu optimieren. Da die 
--- Statistik nur die Befehle anzeigt, die sich gerade im SQL-Cache befinden, 
--- muss die folgende Abfrage ggf. mehrfach täglich zu unterschiedlichen 
--- Zeitpunkten aufgerufen werden.
---
--- Die Einschränkung " buffer_gets > 1000" dient dazu, die Ergebnismenge zu 
--- reduzieren. Es werden damit nur relevante Befehle angezeigt.

SELECT 
  to_char(executions, '999G999G990') "Executions",
  to_char(buffer_gets, '999G999G990') "Gets",
  to_char(buffer_gets/greatest(nvl(executions,1),1), '999G999G990') "Gets / Exec",
  to_char (round(100*(1-(disk_reads/greatest(nvl(buffer_gets,1),1))),2), '990D00') "Hit Ratio",
  sql_text
FROM v$sql
WHERE buffer_gets > 1000
ORDER BY buffer_gets DESC;