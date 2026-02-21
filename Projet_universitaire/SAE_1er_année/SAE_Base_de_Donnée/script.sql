CREATE TABLE regions (
  code INTEGER PRIMARY KEY,
  nom VARCHAR NOT NULL
  ); 
  
CREATE TABLE departements (
  code VARCHAR PRIMARY KEY,
  region INTEGER REFERENCES regions (code) ON DELETE SET NULL ,
  nom VARCHAR NOT NULL
  );
  
CREATE TABLE communes(
  code VARCHAR PRIMARY KEY ,
  departement VARCHAR REFERENCES departements (code) ON DELETE SET NULL,
  nom VARCHAR NOT NULL
  );
 
CREATE TABLE sites (
  idSite VARCHAR PRIMARY KEY ,
  nom VARCHAR NOT NULL ,
  codeCommune VARCHAR REFERENCES communes (code) ON DELETE SET NULL,
  dateDeclaration DATE ,
  typeEau VARCHAR NOT NULL ,
  longitude FLOAT,
  latitude FLOAT
  ) ;
  
CREATE TABLE evenements (
  idEvenement bigint GENERATED ALWAYS AS IDENTITY ,
  idSite VARCHAR REFERENCES sites (idSite) ON DELETE SET NULL ,
  evenement VARCHAR,
  debut DATE,
  fin DATE,
  mesure VARCHAR 
  ); 
  
CREATE TABLE analyses (
  idAnalyse bigint GENERATED ALWAYS AS IDENTITY,
  idSite VARCHAR REFERENCES sites (idSite) ON DELETE SET NULL ,
  datePrelevement DATE ,
  enterocoques INTEGER ,
  escherichia INTEGER
  ) ;
  
 




--Peupler le table regions 

CREATE TEMP TABLE regions_doc( 
  code_departement VARCHAR,
  nom_departement VARCHAR,
  code_region INTEGER,
  nom_region VARCHAR
 );

\copy regions_doc
FROM './departements-france.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO regions(code, nom)
SELECT DISTINCT code_region, nom_region
FROM regions_doc;

SELECT * FROM regions;

---Peuplement du table département

CREATE TEMP TABLE departement_doc( 
  code_departement VARCHAR,
  nom_departement VARCHAR,
  code_region INTEGER,
  nom_region VARCHAR
 );
 
\copy departement_doc(code_departement, nom_departement, code_region, nom_region)
FROM './departements-france.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO departements (code, region, nom)
SELECT code_Departement, code_region, nom_departement 
FROM departement_doc;

SELECT * FROM departements;


---Peuplement du table Commune et site
CREATE TEMP TABLE communes_sites_doc(
  saison_balnéaire INTEGER, 
  région VARCHAR,
  departement VARCHAR,
  code_unique_identification_du_site_de_baignade VARCHAR,
  précédent_code_unique_identification_du_site_de_baignade VARCHAR,
  evolution_2024_vs_2023 VARCHAR,
  nom_du_site_de_baignade VARCHAR,
  code_insee_de_la_commune VARCHAR, 
  nom_de_la_commune VARCHAR,
  date_déclaration_UE DATE,
  type_eau VARCHAR,
  longitude TEXT,
  latitude TEXT
 ); 
 
\copy communes_sites_doc(Saison_balnéaire, Région, Departement, Code_unique_identification_du_site_de_baignade, Précédent_code_unique_identification_du_site_de_baignade, Evolution_2024_vs_2023, Nom_du_site_de_baignade, Code_INSEE_de_la_commune, Nom_de_la_commune, Date_déclaration_UE, Type_eau, Longitude, Latitude)
FROM './liste-des-sites-de-baignade-saison-balneaire-2024.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'LATIN1';

ALTER TABLE communes_sites_doc
ALTER COLUMN longitude TYPE FLOAT USING REPLACE (longitude, ',', '.')::FLOAT,
ALTER COLUMN latitude TYPE FLOAT USING REPLACE(latitude, ',', '.')::FLOAT;

---Peuplement du table Commune

INSERT INTO communes (code, departement, nom)
SELECT DISTINCT code_insee_de_la_commune, departement, nom_de_la_commune
FROM communes_sites_doc;

SELECT * FROM communes;

---Peuplement du table sites
 
INSERT INTO sites (idSite, nom, dateDeclaration, typeEau, longitude, latitude)
SELECT code_unique_identification_du_site_de_baignade, nom_du_site_de_baignade, date_déclaration_UE, type_eau, longitude, latitude
FROM communes_sites_doc;

SELECT * FROM sites;


---Peuplement du table evenements

CREATE TEMP TABLE evenements_doc(
  saison_balnéaire INTEGER, 
  région VARCHAR,
  departement VARCHAR,
  code_unique_identification_du_site_de_baignade VARCHAR,
  type_événement VARCHAR,
  debut DATE,
  fin DATE,
  mesure VARCHAR
 );

\copy evenements_doc(saison_balnéaire, région, departement, Code_unique_identification_du_site_de_baignade, type_événement, debut, fin, mesure)
FROM './saison-balneaire-2024-informations-sur-la-saison.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'LATIN1';
 
INSERT INTO evenements (idSite, evenement, debut, fin, mesure)
SELECT code_unique_identification_du_site_de_baignade, type_événement, debut, fin, mesure
FROM evenements_doc;

SELECT * FROM evenements;


---Peuplement du table analyses
 
CREATE TEMP TABLE analyses_doc (
  saison_balnéaire INTEGER,
  région VARCHAR,
  département VARCHAR,
  code_unique_identification_du_site_de_baignade VARCHAR,
  datePrélèvement DATE,
  enterocoques INTEGER,
  escherichia INTEGER,
  statut_du_prélèvement VARCHAR
 );

ALTER TABLE analyses_doc
ADD COLUMN c9 VARCHAR,
ADD COLUMN c10 VARCHAR,
ADD COLUMN  c11 VARCHAR;


\copy analyses_doc(saison_balnéaire, région, département, code_unique_identification_du_site_de_baignade, datePrélèvement, enterocoques, escherichia, statut_du_prélèvement, c9, c10, c11)
FROM './saison-balneaire-2024-resultats-danalyses.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'LATIN1';

 
INSERT INTO analyses (idSite, datePrelevement, enterocoques, escherichia)
SELECT code_unique_identification_du_site_de_baignade, datePrélèvement , enterocoques, escherichia
FROM analyses_doc;


SELECT * FROM analyse;


  

  
