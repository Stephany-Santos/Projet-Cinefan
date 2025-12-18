SET client_encoding to UTF8;
-- DROP
DROP TABLE IF EXISTS participe CASCADE;
DROP TABLE IF EXISTS commente CASCADE;
DROP TABLE IF EXISTS image CASCADE;
DROP TABLE IF EXISTS personnage CASCADE;
DROP TABLE IF EXISTS media CASCADE;
DROP TABLE IF EXISTS artiste CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS utilisateur CASCADE;

-- CREATE TABLES
CREATE TABLE genre (
    intitule VARCHAR(50) PRIMARY KEY,
    description TEXT
);

CREATE TABLE utilisateur (
    pseudo VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(50),
    biographie TEXT,
    typeDeCompte VARCHAR(20) DEFAULT 'standard',
    mail VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(100) NOT NULL,
    dateDeCreation DATE NOT NULL DEFAULT CURRENT_DATE,
    CHECK ( typeDeCompte IN ('standard', 'admin', 'source') )
);

CREATE TABLE artiste (
    id_artiste SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100) NOT NULL,
    biographie TEXT,
    cree_par VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT NOT NULL
);

CREATE TABLE media (
    id_media SERIAL PRIMARY KEY,
    titre VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parution DATE,
    type VARCHAR(50) NOT NULL,
    realise INT NOT NULL REFERENCES artiste(id_artiste) ON DELETE RESTRICT,
    suite INT REFERENCES media(id_media),
    genre VARCHAR(50) REFERENCES genre(intitule),
    cree_par VARCHAR(20) DEFAULT 'deleted-user' NOT NULL REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT
);

CREATE TABLE personnage (
    id_perso SERIAL PRIMARY KEY,
    nom VARCHAR(40),
    prenom VARCHAR(40) NOT NULL,
    description TEXT,
    cree_par VARCHAR(20) DEFAULT 'deleted-user' NOT NULL REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT,
    media INT NOT NULL REFERENCES media(id_media) ON DELETE RESTRICT
);

CREATE TABLE image (
    fichier VARCHAR(50) PRIMARY KEY,
    lien TEXT,
    alt TEXT,
    media INT REFERENCES media(id_media),
    artiste INT REFERENCES artiste(id_artiste),
    personnage INT REFERENCES personnage(id_perso),
    cree_par VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT NOT NULL,
    CHECK ( ((media IS NOT NULL)::int) + ((artiste IS NOT NULL)::int) + ((personnage IS NOT NULL)::int) = 1 )
);

CREATE TABLE commente (
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    texte TEXT,
    note DECIMAL(2,1) NOT NULL,
    utilisateur VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT,
    id_media INT REFERENCES media(id_media),
    favori BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (utilisateur, id_media, date),
    CHECK (note BETWEEN 0 AND 5),
    CONSTRAINT fk_commente_media FOREIGN KEY (id_media) REFERENCES media(id_media) ON DELETE CASCADE
);

CREATE TABLE participe (
    id_artiste INT REFERENCES artiste(id_artiste) ON DELETE CASCADE,
    id_media  INT REFERENCES media(id_media)   ON DELETE CASCADE,
    id_perso  INT DEFAULT 0 REFERENCES personnage(id_perso),
    role VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_artiste, id_media, id_perso, role)
);