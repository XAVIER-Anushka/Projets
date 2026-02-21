CREATE TABLE Édition (
  id_édition bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nom VARCHAR NOT NULL,
  format VARCHAR NOT NULL,
  isbn VARCHAR
  ); 

CREATE TABLE Livre (
  id_livre bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nom VARCHAR,
  type VARCHAR,
  genre VARCHAR,
  annee_de_sortie INTEGER,
  édition bigint REFERENCES Édition (id_édition) ON DELETE SET NULL,
  nombre_pages INTEGER
  );

CREATE TABLE Exemplaire (
  id_exemplaire bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_livre bigint REFERENCES Livre (id_livre) ON DELETE SET NULL,
  état_du_exemplaire VARCHAR NOT NULL,
  disponibilité iNTEGER
  );

CREATE TABLE Personne(
  id_personne bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nom VARCHAR NOT NULL,
  prenom VARCHAR NOT NULL
  );

CREATE TABLE Auteur (
  id_auteur bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_personne bigint REFERENCES Personne (id_personne) ON DELETE SET NULL
  );

CREATE TABLE Auteur_du_Livre (
  id_livre bigint REFERENCES Livre (id_livre) ON DELETE SET NULL,
  id_Auteur bigint REFERENCES Auteur (id_auteur) ON DELETE SET NULL
  );
 
CREATE TABLE Abonnée (
  id_abonnée bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_personne bigint REFERENCES Personne (id_personne) ON DELETE SET NULL,
  âge INTEGER NOT NULL,
  numéro_téléphone INTEGER NOT NULL,
  email VARCHAR NOT NULL,
  Adresse VARCHAR NOT NULL
  );
  
CREATE TABLE Emprunter (
  id_exemplaire bigint REFERENCES Exemplaire (id_exemplaire) ON DELETE SET NULL,
  id_abonnée bigint REFERENCES Abonnée (id_abonnée) ON DELETE SET NULL
  );
  

  

