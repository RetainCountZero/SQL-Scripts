<< Render_main >>
DECLARE
-- global variables go here
  cm_active VARCHAR2(10) := 0;
  cm_book_id VARCHAR2(20) := NULL;
  cm_percent VARCHAR2(20) := 0.0;
  cm_string VARCHAR2(2000) := NULL;
  cm_head VARCHAR(128) := NULL;
  cm_tail VARCHAR(2000) := NULL;
  
  cm_blob_max_size NUMBER;
  cm_blob_chunk_size NUMBER;
  cm_blob_offset NUMBER;
  cm_blob_next_chunk VARCHAR2(2000);
  
  /*
     Return the first part of a string, up to the character %.
  */
  FUNCTION cm_make_head (fullstring IN VARCHAR2, 
                         delimiter IN VARCHAR2 default '%')
  RETURN VARCHAR2 IS
  BEGIN
    RETURN substr(fullstring, 1, instr(fullstring, delimiter, 1) - 1);
  END;
  
  /*
     Return the rest of a string, after the character %.
     Note: If there is no % in the string, an empty string is returned.
           It is assumed that in this case the "tail" is malformed.
  */
  FUNCTION cm_make_tail (fullstring IN VARCHAR2,
                         delimiter IN VARCHAR2 default '%')
  RETURN VARCHAR2 IS
    tail VARCHAR2(2000);
  BEGIN
    IF instr(fullstring, delimiter) = 0 THEN
      tail := NULL;
    ELSE 
      tail := substr(fullstring, instr(fullstring, delimiter, 1) + 1);
    END IF;
    RETURN tail;
  END;
  
  /* Get the status value as number */
  FUNCTION cm_parse_for_status (text IN VARCHAR2)
  RETURN NUMBER IS
  BEGIN
    RETURN TO_NUMBER(substr(text, 1, instr(text, ';', 1) - 1));
  END;
  
  /* Get the book ID as number */
  FUNCTION cm_parse_for_book_id (text IN VARCHAR2)
  RETURN NUMBER IS
  BEGIN
    RETURN TO_NUMBER(substr(text, 3, instr(text, ';', 1, 2) - 3));
  END;
  
  /* Get the percentage as number */
  FUNCTION cm_parse_for_percentage (text IN VARCHAR2)
  RETURN NUMBER IS
  BEGIN
    RETURN TO_NUMBER(substr(text, instr(text, ';', 1, 2) + 1));
  END;
  
  /* Translate a status (0, 1) to (ja, nein) */
  FUNCTION cm_get_book_status (status IN NUMBER)
  RETURN VARCHAR2 IS
    status_s VARCHAR2(4);
  BEGIN
    IF status = 0 THEN
      status_s := 'Nein';
    ELSE
      status_s := 'Ja';
    END IF;
    RETURN status_s;
  END;
  
  /* Returns the book name for a supplied book ID */
  FUNCTION cm_get_book_name (book_id IN NUMBER)
  RETURN VARCHAR2 IS
    book_name VARCHAR2(60 BYTE);
  BEGIN
    SELECT name_s 
    INTO book_name 
    FROM stationbase
    WHERE ident = book_id;
    RETURN book_name;
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RETURN '--- Book is missing ---';
  END;
  
  /* 
     HTML output related procedures 
  */
  /* The static header and some CSS */
  PROCEDURE cm_html_header
  IS
  BEGIN
    dbms_output.put_line('<!DOCTYPE html>');
    dbms_output.put_line('<html>');
    dbms_output.put_line('<head>');
    dbms_output.put_line('<meta charset="UTF-8">');
    dbms_output.put_line('<title>Buch-Templates des Energiemengen Verteilens in BelVis3 PFM</title>');
    
    dbms_output.put_line('<style>');
    dbms_output.put_line('* {margin-left: 40px; margin-right: 40px;}');
    dbms_output.put_line('table { border-collapse: collapse; width: 75%;}');
    dbms_output.put_line('td, th { border: 1px solid #606060; text-align: center; padding: 6px;}');
    dbms_output.put_line('tr:nth-child(even) { background-color: #dddddd;}');
    dbms_output.put_line('.lightTableRow, .lightTableRow TD, lightTableRow TR {color: #999999;}');
    dbms_output.put_line('.darkTableRow, .darkTableRow TD, darkTableRow TR {color: #000000;}');
    dbms_output.put_line('.tableHeaderRow, .tableHeaderRow TR {color: #FFFFFF; background-color: #333399;}');
    dbms_output.put_line('</style>');
    
    dbms_output.put_line('</head>');
    dbms_output.put_line('<body>');
  END;

  /* The static footer */    
  PROCEDURE cm_html_footer
  IS
  BEGIN
    dbms_output.put_line('</body>');
    dbms_output.put_line('</html>');
  END;
  
  /* The Table of Contents (TOC). Supplies anchors to parts of the document. */
  PROCEDURE cm_html_toc
  IS
  BEGIN
    dbms_output.put_line('<h1>Übersicht der Templates:</h1>');
    FOR i IN (SELECT name_s FROM wk_config WHERE type_l IN (1001, 1004, 1008))
    LOOP
      dbms_output.put_line('<a href="#' || i.name_s || '">' || i.name_s || '</a><br>');
    END LOOP;
  END;
  
  /* The header of a table */
  PROCEDURE cm_html_table_header
  IS
  BEGIN
    dbms_output.put_line('<table>');
    dbms_output.put_line('<tr class="tableHeaderRow"><th>Status aktiv?</th><th>Buch Ident / Buch Name</th><th>Prozentanteil</th></tr>');
  END;
  
  /* The footer of a table */
  PROCEDURE cm_html_table_footer
  IS
  BEGIN
    dbms_output.put_line('</table>');
  END;
  
  /* A row of the table.  Conditional formatting via CSS */
  PROCEDURE cm_html_result_line(status VARCHAR2,
                                book_id NUMBER,
                                percentage NUMBER)
  IS
  BEGIN
    IF (status = 0 OR percentage = 0) THEN
      dbms_output.put('<tr class="lightTableRow"><td>' || cm_get_book_status(status) || '</td>');
      dbms_output.put('<td>' || book_id ||'/' || cm_get_book_name(book_id) || '</td>');
      dbms_output.put_line('<td>' || percentage || '</td></tr>');
 
    ELSE
      dbms_output.put('<tr class="darkTableRow"><td>' || cm_get_book_status(status) || '</td>');
      dbms_output.put('<td>' || book_id ||'/' || cm_get_book_name(book_id) || '</td>');
      dbms_output.put_line('<td>' || percentage || '</td></tr>');
    END IF;
  END;
  
/* The main anonymous procedure */
BEGIN
  dbms_output.enable(NULL);
  cm_blob_chunk_size := 896;  --896
  cm_blob_offset := 1;
  
  -- render the HTML header
  cm_html_header;
  -- render the Table of Contents
  cm_html_toc;
  
  -- Loop over all entries in WK_CONFIG of type_l = 1001, 1004, 1008
  << WK_CONFIG_LOOP >>
  FOR i IN (SELECT 
              name_s,
              datasize_l,
              utl_raw.cast_to_varchar2(dbms_lob.substr(data_bl, cm_blob_chunk_size, cm_blob_offset)) AS raw_text
            FROM wk_config 
            WHERE type_l IN (1001, 1004, 1008))
  LOOP -- over all items in WK_CONFIG
    IF i.datasize_l > 0 THEN
      dbms_output.put_line('<h1 id="' || i.name_s || '">Template: ' || i.name_s || '</h1>');
      -- initialize some values      
      cm_blob_max_size := i.datasize_l;
      cm_blob_offset := 1;
      cm_string := i.raw_text;

      -- split data into head and tail
      cm_head := cm_make_head(cm_string);
      cm_tail := cm_make_tail(cm_string);
      -- process head
      cm_active := cm_parse_for_status(cm_head);
      cm_book_id := cm_parse_for_book_id(cm_head);
      cm_percent := cm_parse_for_percentage(cm_head);
      -- render table header
      cm_html_table_header;
      -- render first table row
      cm_html_result_line(cm_active, cm_book_id, cm_percent);
      -- process tail
      -- either just create a new head from tail
      -- or load additional data and create a new head from tail
      <<TAIL_LOOP >>
      WHILE (cm_tail IS NOT NULL)
      LOOP -- TAIL LOOP
        -- Are we running low on characters? Perhaps use 64 here.
        IF (length(cm_tail) <= 32) THEN
          -- load the next chunk from the blob and add it to the tail
          cm_blob_offset := cm_blob_offset + cm_blob_chunk_size;
          SELECT utl_raw.cast_to_varchar2(dbms_lob.substr(data_bl, cm_blob_chunk_size, cm_blob_offset))
          INTO cm_blob_next_chunk
          FROM wk_config
          WHERE name_s = i.name_s;
          -- Concatenate the new string to the old string
          cm_tail := cm_tail || cm_blob_next_chunk;
        END IF;
        
        cm_string := cm_tail;
        cm_head := cm_make_head(cm_string);
        cm_active := cm_parse_for_status(cm_head);
        cm_book_id := cm_parse_for_book_id(cm_head);
        cm_percent := cm_parse_for_percentage(cm_head);
        cm_html_result_line(cm_active, cm_book_id, cm_percent);
        -- Reduce tail
        cm_tail := cm_make_tail(cm_string);
      END LOOP TAIL_LOOP;
      
      cm_tail := cm_make_head(cm_make_tail(cm_tail));
      IF cm_tail IS NOT NULL THEN
      -- Process the final line
        cm_active := cm_parse_for_status(cm_tail);
        cm_book_id := cm_parse_for_book_id(cm_tail);
        cm_percent := cm_parse_for_percentage(cm_tail);
        -- render final table row
        cm_html_result_line(cm_active, cm_book_id, cm_percent);
      END IF;
      
      -- render table footer
      cm_html_table_footer;
      
    END IF; 
    -- do nothing if datasize_l = 0
  END LOOP WK_CONFIG_LOOP; -- over all items in WK_CONFIG
  -- render last HTML elements to close the document
  cm_html_footer;
  
END;
/