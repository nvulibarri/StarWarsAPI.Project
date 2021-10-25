/*
--Adding processed column:
ALTER TABLE StarWarsJson ADD Processed bit

UPDATE StarWarsJson
SET Processed = 0
WHERE Processed IS NULL;

--Replacing single quote to double for string to convert to json
UPDATE StarWarsJson
SET Json_Data = REPLACE(Json_Data, '''', '"');


CREATE TABLE #TempTable(ID INT, [Key] VARCHAR(MAX), [Value] VARCHAR(MAX))

*/
--

SELECT * FROM StarWarsJson ORDER BY ID


--Below is creating a temp table to store the parsed json on each charactor, looping through the table to parse row by row.

DECLARE @F NVARCHAR(MAX), @Row INT

WHILE EXISTS(
	SELECT TOP 1 * 
	FROM StarWarsJson
	WHERE Processed = 0) 
BEGIN 
	SELECT TOP 1 @Row = ID, @F = Json_Data 
	FROM StarWarsJson 
	WHERE Processed = 0
	
	INSERT INTO #TempTable(ID, [Key], [Value])
	SELECT @Row, [Key], [Value] 
	FROM OpenJson(@F)

	UPDATE StarWarsJson	
	SET Processed = 1 
	WHERE ID = @Row
END


SELECT * FROM #TempTable

-- CREATE PEOPLE TABLE AND INSERT CHARACTOR DATA
CREATE TABLE PEOPLE (
ID INT PRIMARY KEY
,IDType VARCHAR(100)
,[name] VARCHAR(100)
,height DECIMAL(18, 2)
,mass DECIMAL(18, 2)
,hair_color VARCHAR(100)
,skin_color VARCHAR(100)
,eye_color VARCHAR(100)
,birth_year VARCHAR(100)
,gender VARCHAR(100)
,homeworld NVARCHAR(MAX)
,films NVARCHAR(MAX)
,species NVARCHAR(MAX)
,vehicles NVARCHAR(MAX)
,starships NVARCHAR(MAX)
,[url] NVARCHAR(MAX)
)

SELECT * FROM PEOPLE


-- Inserting data into PEOPLE table, filtering out unwanted values:


INSERT INTO [dbo].[PEOPLE]
           ([ID]
		   ,[name]
           ,[height]
           ,[mass]
           ,[hair_color]
           ,[skin_color]
           ,[eye_color]
		   ,[birth_year]
           ,[gender]
           ,[homeworld]
		   ,[films]
		   ,[species]
		   ,[vehicles]
		   ,[starships]
		   ,[url])
SELECT DISTINCT 
			ID
		   ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'name' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found') 		   
           ,(SELECT REPLACE([VALUE], ',', '') FROM #TempTable TT WHERE [KEY] = 'height' AND TT.ID = T.ID AND TT.[VALUE] NOT IN('unknown', 'Not found'))
           ,(SELECT REPLACE([VALUE], ',', '') FROM #TempTable TT WHERE [KEY] = 'mass' AND TT.ID = T.ID AND TT.[VALUE] NOT IN('unknown', 'Not found'))
           ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'hair_color' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
           ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'skin_color' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
           ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'eye_color' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
		   ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'birth_year'  AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
           ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'gender' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
           ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'homeworld' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
		   ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'films' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
		   ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'species' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
		   ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'vehicles' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
		   ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'starships' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
		   ,(SELECT [VALUE] FROM #TempTable TT WHERE [KEY] = 'url' AND TT.ID = T.ID AND TT.[VALUE] != 'Not found')
FROM #TempTable T
WHERE T.[KEY] != 'detail'



SELECT * FROM PEOPLE

/*
---set IDType
UPDATE PEOPLE
SET IDType = 'Person'
WHERE IDType IS NULL;
*/



--removing http and leaving only id numbers for homeworld, films, species, vehicles, starships columns
/*
UPDATE PEOPLE
SET starships = REPLACE(starships, '', '');

SELECT * FROM PEOPLE

*/