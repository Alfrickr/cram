CREATE TABLE IF NOT EXISTS sue1(
   id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  CVE_Number VARCHAR(16) NOT NULL,
  Vulnerability_Score NUMERIC(3,1) NOT NULL,
  Node VARCHAR(100) NOT NULL,
  SW_Make VARCHAR(50) NOT NULL,
  SW_Description VARCHAR(84),
  SW_Version VARCHAR(23) NOT NULL,
  Table_Ref VARCHAR(5) NOT NULL
  );
  
 SELECT 'list' AS component, 'You\'re in the SUE1 page' AS title;
 SELECT 'Home' AS title, 'NSWCDD Hackathon Hub' AS description,  '/' AS link;

-- Insert new record only if all fields are provided and no edit is in progress
INSERT INTO sue1 (CVE_Number, Vulnerability_Score, Node, SW_Make, SW_Description, SW_Version, Table_Ref)
SELECT :CVE_Number, :Vulnerability_Score, :Node, :SW_Make, :SW_Description, :SW_Version, :Table_Ref
WHERE :CVE_Number IS NOT NULL AND $edit IS NULL;

-- Update the record when editing
UPDATE sue1
SET CVE_Number = :CVE_Number, 
Vulnerability_Score = :Vulnerability_Score, 
Node = :Node,  
SW_Make = :SW_Make, 
SW_Description = :SW_Description, 
SW_Version = :SW_Version,  
Table_Ref = :Table_Ref
WHERE id = $edit AND :CVE_Number IS NOT NULL;

-- Delete the record
-- doesn't even work on it's own
--DELETE FROM sue1 WHERE CVE_Number=$del;
DELETE FROM sue1 WHERE id=$delete;
DELETE FROM sue1 WHERE CVE_Number = $del collate utf8mb4_0900_ai_ci


-- Delete the record
--DELETE FROM sue1 WHERE CVE_Number= $del;

-- Redirect to clear form after insert, update, or deletion confirmation
--SELECT 'redirect' AS component, 'example-remove' AS link
--WHERE 
	--$del is NOT NULL AND :CVE_Number IS NOT NULL;
  --  ($id IS NOT NULL AND :CVE_Number IS NOT NULL)  -- Redirect after adding a new record
   -- OR ($edit IS NOT NULL AND :Name IS NOT NULL)  -- Redirect after editing a record
    --OR ($delete IS NOT NULL );  -- Redirect after confirming deletion


--DELETE FROM sue1 WHERE  :CVE_Number IS NOT NULL AND CVE_Number = :CVE_Number;
-- doesn't wor kas intended
--DELETE FROM sue1 WHERE id=$remove OR id=$CVE_Number;
-- delete CVE

-- depreciated cve number deletion textbox
--SELECT 'form' AS component, 
--'Delete' AS validate, 
--'red' AS validate_color;
--SELECT 'CVE_Number' as CVE_Number, 'CVE Number' as label;




-- Conditionally show the form for editing or adding a new entry
--SELECT 'form' AS component;
--'Edit' as title,
--'Submit Edit' as validate;
-- Populate form fields for both adding and editing
--SELECT (SELECT id FROM sue1 WHERE id = $edit) AS value, 'ID' AS disabled, 'ID' AS name;
--SELECT (SELECT CVE_Number FROM sue1 WHERE id = $edit)  AS value, 'CVE Number' AS name;
--SELECT (SELECT Vulnerability_Score FROM sue1 WHERE id = $edit) AS value, 'Vulnerability Score' AS name;
--SELECT (SELECT Node FROM sue1 WHERE id = $edit) AS value, 'Node' AS name;
--SELECT (SELECT SW_Make FROM sue1 WHERE id = $edit) AS value, 'Software Name' AS name;
--SELECT (SELECT SW_Description FROM sue1 WHERE id = $edit) AS value, 'Software Description' AS name;
--SELECT (SELECT SW_Version FROM sue1 WHERE id = $edit) AS value, 'Software Version' AS name;
--SELECT (SELECT Table_Ref FROM sue1 WHERE id = $edit) AS value, 'Table' AS name;

-- Add "Add New" button to set the $add parameter
--SELECT 'button' as component, 'center' as justify;
--SELECT '?add=1' as link, 'Add New' as title;  -- Dynamic link for add new

--DELETE FROM sue1 WHERE CVE_Number= $edit;

--SELECT 'redirect' AS component, 'redirect_sue1.sql' AS link WHERE $del IS NOT NULL;

--SELECT 'redirect' AS component, 'form_with_table.sql' AS link WHERE $delete IS NOT NULL;

--SELECT 'steps' as component;
SELECT 'title' as component,
CONCAT('Security Score: ', (SELECT IFNULL(100-(SUM(POW(Vulnerability_Score,2)) / COUNT(*)), "N/A") FROM SUE1) , ' / 100') AS contents,
2 as level;

SELECT
	'button' as component;
SELECT
	'/insert_into_sue1.sql' as link,
CONCAT((SELECT IF((SELECT COUNT(TABLE_NAME) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME='SUE1') = 0, "Create", "Recreate")), ' SUE1 Table')  as title;

-- Display the table with actions
SELECT 'table' AS component,
    'CVE' AS markdown, 'ID2' AS markdown, TRUE AS sort, TRUE AS search;
SELECT  
	 id AS ID,
     CVE_Number AS "CVE Number", 
     Vulnerability_Score AS "Vulnerability Score", 
     Node AS Node,
	 SW_Make AS "Software Make",
	 SW_Description AS "Software Description",
	 SW_Version AS "Software Version",
	 Table_REF as "Table",
    '[🗑️CVE](?del=' || CVE_Number || ')' AS CVE,          -- Dynamic link for edit
    '[🗑️ID](?delete=' || id || ')' AS ID2        -- Dynamic link for delete
FROM sue1;