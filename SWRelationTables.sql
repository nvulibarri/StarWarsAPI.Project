TRUNCATE TABLE SPECIESxPLANETS

CREATE TABLE SPECIESxPLANETS(
		SPECIESxPLANETS_ID INT IDENTITY PRIMARY KEY
		,PLANETS_ID INT
		,SPECIES_ID INT
		)


---using the cross apply and split string to parse out ID's for the corrilating columns of tables, creating tableXtable relations

INSERT INTO [dbo].[SPECIESxPLANETS]
           ([PLANETS_ID]
           ,[SPECIES_ID]
		   )
SELECT PLANETS_ID = R.value
	,SPECIES_ID = P.ID
FROM dbo.SPECIES P 
CROSS APPLY string_split
(
	homeworld, ','
) R


SELECT * FROM PLANETS

SELECT * FROM SPECIES

SELECT * FROM SPECIESxPLANETS


/*
---replace strings in columns with int to make cross apply work
UPDATE SPECIES
SET homeworld = REPLACE(homeworld, 'NONE', 0);
---

---select statments for correlated tables:
SELECT * FROM PEOPLExPLANETS
SELECT * FROM PEOPLExFILMS
SELECT * FROM PEOPLExSPECIES
SELECT * FROM PEOPLExVEHICLES
SELECT * FROM PEOPLExSTARSHIPS

SELECT * FROM FILMSxSTARSHIPS
SELECT * FROM FILMSxSPECIES
SELECT * FROM FILMSxPLANETS
SELECT * FROM FILMSxVEHICLES

SELECT * FROM SPECIESxPLANETS

*/



---Joining tables, creating new tables that will be used in PowerBI:

--planet and population details:
CREATE TABLE dbo.PlanetDetails(
	PlanetName VARCHAR(100)
	,PlanetDiameter INT
	,PlanetRotationInDays INT
	,PlanetOrbitInDays INT
	,PlanetGravity VARCHAR(100)
	,PlanetClimate VARCHAR(100)
	,PlanetPopulation BIGINT
	,PlanetTerrain VARCHAR(150)
	,PlanetSurfaceWater INT
	,SpeciesName VARCHAR(100)
	,SpeciesClassification VARCHAR(100)
	,SpeciesLanguage VARCHAR(100)
	)


INSERT INTO [dbo].[PlanetDetails](
	PlanetName
	,PlanetDiameter
	,PlanetRotationInDays
	,PlanetOrbitInDays
	,PlanetGravity
	,PlanetClimate
	,PlanetPopulation
	,PlanetTerrain
	,PlanetSurfaceWater
	,SpeciesName
	,SpeciesClassification
	,SpeciesLanguage
	)


	
SELECT
	PlanetName=P.[name]
	,PlanetDiameter= CAST(REPLACE(P.[diameter], 'unknown', 0) AS INT)
	,PlanetRotationInDays=CAST(REPLACE(P.[rotation_period], 'unknown', 0) AS INT)
	,PlanetOrbitInDays=CAST(REPLACE(P.[orbital_period], 'unknown', 0) AS INT)
	,PlanetGravity=P.[gravity]
	,PlanetClimate=P.[climate]
	,PlanetPopulation=CAST(REPLACE(P.[population], 'unknown', 0) AS BIGINT)
	,PlanetTerrain=P.[terrain]
	,PlanetSurfaceWater=CAST(REPLACE(P.[surface_water], 'unknown', 0) AS FLOAT)
	,SpeciesName=S.[name]
	,SpeciesClassification=S.[Classification]
	,SpeciesLanguage=S.[language]
FROM dbo.SPECIESxPLANETS SXP 
INNER JOIN dbo.SPECIES S 
	ON S.ID = SXP.SPECIES_ID
INNER JOIN dbo.PLANETS P 
	ON P.ID = SXP.PLANETS_ID
ORDER BY PlanetName


SELECT *
FROM PlanetDetails





--vehicle and pilot details, TODO: create and insert into table

SELECT
	VehicleName=P.[name]
	,VehicleModel=P.[model]
	,VehicleClass=P.[vehicle_class]
	,VehicleManufacturer=P.[manufacturer]
	,VehicleLength=P.[length]
	,VehicleCost=P.[cost_in_credits]
	,PilotName=S.[name]
	,PilotHeight=S.[height]
	,PilotWeight=S.[mass]
	,PilotGender=S.[gender]
	,PilotHomeWorld=A.[name]
	,PilotSpecies=T.[name]
	,PilotSpecies_ID=T.[ID]
FROM dbo.PEOPLExVEHICLES PPxV 
INNER JOIN dbo.PEOPLE S 
	ON S.ID = PPxV.PEOPLE_ID
INNER JOIN dbo.VEHICLES P 
	ON P.ID = PPxV.VEHICLES_ID
INNER JOIN dbo.PEOPLExPLANETS PxP
	ON S.ID = PxP.PEOPLE_ID
INNER JOIN dbo.PLANETS A
	ON PXP.PLANET_ID = A.ID
LEFT JOIN dbo.PEOPLExSPECIES PPxS
	ON S.ID = PPxS.PEOPLE_ID
LEFT JOIN dbo.SPECIES T
	ON PPxS.SPECIES_ID = T.ID



---People and the films they're in, TODO: create and insert into table
SELECT CharacterName=C.[name]
	,InFilms=F.[title]
	,Episode=F.[episode_id]
	,FilmReleaseDate=F.[release_date]
	,Directors=F.[director]
	,Producer=F.[producer]
FROM dbo.PEOPLExFILMS PxF
INNER JOIN dbo.PEOPLE C 
	ON C.ID = PxF.PEOPLE_ID
INNER JOIN dbo.FILMS F 
	ON F.ID = PxF.FILM_ID
ORDER BY CharacterName





SELECT *
FROM PEOPLE


SELECT *
FROM FILMS


SELECT *
FROM dbo.PEOPLExspecies

SELECT *
FROM VEHICLES

SELECT *
FROM PLANETS



