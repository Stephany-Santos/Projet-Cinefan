/**
 *	-------- Projet CINEFAN -----
 *              TP 12
 *  par Flore, Niekita Joseph
 *  et Stephany Santos Fereira de Sousa
 * -------------------------------
**/

/**
 *	Tables SQL
**/
-- Notes : Impossible de mettre le cree_par dans table Media car cause des problèmes de non définition des tables (les deux se référenceraient mutuellement, et la présence de Favori dans utilisateur est plus importante)
------------------------- ADD CONSTRAINT !!!
CREATE TABLE genre (
    intitule VARCHAR(50) PRIMARY KEY,
    description TEXT
);

CREATE TABLE artiste (
    id SERIAL PRIMARY KEY,
    nom CHAR(20),
    prenom CHAR(20) NOT NULL,
    role CHAR(20) NOT NULL,
    
    cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL
);

CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parution DATE,
    type VARCHAR(50) NOT NULL,

    realise SERIAL REFERENCES artiste(id)NOT NULL,
    suite SERIAL REFERENCES media(id), 
    genre VARCHAR(50) REFERENCES genre(intitule),
    cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL
);

CREATE TABLE utilisateur (
    pseudo VARCHAR(20) PRIMARY KEY,
    nom VARCHAR(20),
    biographie TEXT,
    typeDeCompte VARCHAR(20) DEFAULT 'standard',
    mail VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(100) UNIQUE NOT NULL,
    dateDeCreation DATE NOT NULL DEFAULT CURRENT_DATE,

    favori SERIAL REFERENCES media(id)
);

CREATE TABLE personnage (
    id SERIAL PRIMARY KEY,
    nom CHAR(40),
    prenom CHAR(40) NOT NULL,
    description TEXT,

    cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL,
    media SERIAL REFERENCES media(id) NOT NULL
);

CREATE TABLE image (
    fichier VARCHAR(50) PRIMARY KEY,
    lien BYTEA,
    alt TEXT,

    media SERIAL REFERENCES media(id),
    artiste SERIAL REFERENCES artiste(id),
    personnage SERIAL REFERENCES personnage(id),
    cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL

);

CREATE TABLE commente (
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    texte TEXT,
    note INT NOT NULL,
    utilisateur VARCHAR(20) REFERENCES utilisateur(pseudo),
    id_media SERIAL REFERENCES media(id),
    PRIMARY KEY (utilisateur, id_media, date)
);

CREATE TABLE participe (
    id_artiste SERIAL REFERENCES artiste(id) NOT NULL,
    id_media SERIAL REFERENCES media(id) NOT NULL,
    id_perso SERIAL REFERENCES personnage(id),
    PRIMARY KEY (id_artiste, id_media, id_perso)
);

/**
 *	Vues SQL pour les Addendums
**/

-- Pour chaque acteur, le nombre de films de chaque genre dans lesquels il a joué,
-- trié par nombre de films descendant.
CREATE VIEW filmsParActeur AS (
    SELECT count(media.genre) AS nombreDeFilms, artiste.nom, artiste.prenom, media.genre
    FROM artiste
)

-- le nombre de critiques écrites par chaque membre du club.

CREATE VIEW nbCritiques AS (

)

-- Le nombre moyen de critiques écrites par utilisateur pour chaque genre.

CREATE VIEW moyenneCritiques AS (

)

/**
 *	Remplissages de tables SQL
**/