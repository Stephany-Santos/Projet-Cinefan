/**
 *	-------- Projet CINEFAN -----
 *              TP 12
 *  par Flore Rigoigne, Niekita Joseph
 *  et Stephany Santos Ferreira de Sousa
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
    nom CHAR(100),
    prenom CHAR(100) NOT NULL,
    role CHAR(20) NOT NULL,
    
    cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL
);

CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parution DATE,
    type VARCHAR(50) NOT NULL,

    realise INT REFERENCES artiste(id) NOT NULL,
    suite INT REFERENCES media(id), 
    genre VARCHAR(50) REFERENCES genre(intitule),
    cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL
);

CREATE TABLE utilisateur (
    pseudo VARCHAR(20) PRIMARY KEY,
    nom VARCHAR(20),
    biographie TEXT,
    typeDeCompte VARCHAR(20) DEFAULT 'standard',
    mail VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(100) NOT NULL,
    dateDeCreation DATE NOT NULL DEFAULT CURRENT_DATE,

    favori INT REFERENCES media(id)
);

CREATE TABLE personnage (
    id SERIAL PRIMARY KEY,
    nom CHAR(40),
    prenom CHAR(40) NOT NULL,
    description TEXT,

    cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL,
    media INT REFERENCES media(id) NOT NULL
);

CREATE TABLE image (
    fichier VARCHAR(50) PRIMARY KEY,
    lien BYTEA,
    alt TEXT,

    media INT REFERENCES media(id),
    artiste INT REFERENCES artiste(id),
    personnage INT REFERENCES personnage(id),
    cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL

);

CREATE TABLE commente (
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    texte TEXT,
    note INT NOT NULL,
    utilisateur VARCHAR(20) REFERENCES utilisateur(pseudo),
    id_media INT REFERENCES media(id),
    PRIMARY KEY (utilisateur, id_media, date)
);

CREATE TABLE participe (
    id_artiste INT REFERENCES artiste(id) NOT NULL,
    id_media INT REFERENCES media(id) NOT NULL,
    id_perso INT REFERENCES personnage(id),
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
    SELECT utilisateur.pseudo, COUNT(commente.utilisateur) AS nombreDeCritiques
    FROM utilisateur
    LEFT JOIN commente ON utilisateur.pseudo = commente.utilisateur
    GROUP BY utilisateur.pseudo
)

-- Le nombre moyen de critiques écrites par utilisateur pour chaque genre.

CREATE VIEW moyenneCritiques AS (
    SELECT media.genre, AVG(nbCritiques.nombreDeCritiques) AS moyenneCritiquesParGenre
    FROM media
    JOIN commente ON media.id = commente.id_media
    JOIN nbCritiques ON commente.utilisateur = nbCritiques.pseudo
    GROUP BY media.genre
)

/**
 *	Remplissages de tables SQL
**/
INSERT INTO genre (intitule, description) VALUES
('Aventure', 'Médias dédiés à l\'exploration et l\'action'),
('Animation', 'Films ou séries réalisés en images animées'),
('Science-fiction', 'Œuvres se déroulant dans un contexte futuriste ou technologique');

INSERT INTO utilisateur (pseudo, nom, biographie, typeDeCompte, mail, mdp, dateDeCreation)
VALUES
('alice', 'Dupont', 'Passionnée de cinéma et de séries.', 'administrateur', 'alice@exemple.fr', 'passwdalice', '2024-02-10'),
('bob42', 'Martin', 'Critique amateur, aime la SF.', 'standard', 'bob42@email.fr', 'passwd42bob', '2025-10-04'),
('charly', 'Leclerc', 'Dessinateur freelance.', 'créateur', 'charly@freelance.fr', 'passwdCharly', '2025-09-22');

INSERT INTO artiste (nom, prenom, role, cree_par)
VALUES
('Spielberg', 'Steven', 'réalisateur', 'alice'),
('Durand', 'Sophie', 'actrice', 'bob42'),
('Smith', 'John', 'doubleur', 'charly');
-- ids générés : 1, 2, 3

INSERT INTO media (titre, description, parution, type, realise, suite, genre, cree_par)
VALUES
('Voyage Stellaire', "Un équipage se lance dans l'espace.", '2023-03-01', 'film', 1, NULL, 'Science-fiction', 'alice'),
('Le Royaume Caché', 'Un jeune garçon découvre un monde secret.', '2022-10-15', 'film', 1, NULL, 'Aventure', 'bob42'),
('Animaliens', 'Une planète habitée par des animaux animés.', '2024-04-20', 'série', 1, NULL, 'Animation', 'charly');
-- ids générés : 1, 2, 3

INSERT INTO personnage (nom, prenom, description, cree_par, media)
VALUES
('Stone', 'Elena', 'Capitaine du vaisseau', 'alice', 1),
('Martin', 'Lucas', 'Héros du royaume caché', 'bob42', 2),
('Tigrou', 'Maxwell', 'Tigre doué de parole', 'charly', 3);
-- ids générés : 1, 2, 3

INSERT INTO image (fichier, lien, alt, media, artiste, personnage, cree_par)
VALUES
('vs_affiche.jpg', NULL, 'Affiche du film Voyage Stellaire', 1, NULL, NULL, 'alice'),
('tgr_maxwell.png', NULL, 'Portrait du personnage Tigrou Maxwell', 3, 3, 3, 'charly'),
('lrk_affiche.jpg', NULL, 'Affiche Le Royaume Caché', 2, NULL, NULL, 'bob42');

INSERT INTO commente (date, texte, note, utilisateur, id_media)
VALUES
('2025-10-10', 'Très beau film, concept original !', 9, 'bob42', 1),
('2025-11-01', "Décors superbes, manque d'action", 7, 'alice', 2),
('2025-11-11', 'Animation bluffante', 8, 'charly', 3);

INSERT INTO participe (id_artiste, id_media, id_perso)
VALUES
(2, 2, 2),
(3, 3, 3),
(1, 1, 1);
