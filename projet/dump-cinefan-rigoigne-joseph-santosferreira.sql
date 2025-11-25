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

CREATE TABLE genre (
    intitule VARCHAR(50) PRIMARY KEY,
    description TEXT
);

CREATE TABLE artiste (
    id_artiste SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100) NOT NULL,
    
    cree_par VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT NOT NULL
);

CREATE TABLE media (
    id_media SERIAL PRIMARY KEY,
    titre VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parution DATE,
    type VARCHAR(50) NOT NULL,

    realise INT REFERENCES artiste(id_artiste) NOT NULL ON DELETE RESTRICT,
    suite INT REFERENCES media(id_media), 
    genre VARCHAR(50) REFERENCES genre(intitule),
    cree_par VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT NOT NULL
);

CREATE TABLE utilisateur (
    pseudo VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(50),
    biographie TEXT,
    typeDeCompte VARCHAR(20) DEFAULT 'standard',
    mail VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(100) NOT NULL,
    dateDeCreation DATE NOT NULL DEFAULT CURRENT_DATE,


    CHECK (
        typeDeCompte IN ('standard', 'admin', 'source')
    )
);

CREATE TABLE personnage (
    id_perso SERIAL PRIMARY KEY,
    nom VARCHAR(40),
    prenom VARCHAR(40) NOT NULL,
    description TEXT,
    
    cree_par VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT NOT NULL,
    media INT REFERENCES media(id_media) NOT NULL ON DELETE RESTRICT
);

CREATE TABLE image (
    fichier VARCHAR(50) PRIMARY KEY,
    lien BYTEA,
    alt TEXT,

    media INT REFERENCES media(id_media),
    artiste INT REFERENCES artiste(id_artiste),
    personnage INT REFERENCES personnage(id_perso),
    cree_par VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT NOT NULL, 
    
    CHECK (
        (media IS NOT NULL)::int +
        (artiste IS NOT NULL)::int +
        (personnage IS NOT NULL)::int = 1
    )
);

CREATE TABLE commente (
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    texte TEXT,
    note DECIMAL(2, 1) NOT NULL,
    utilisateur VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT,
    id_media INT REFERENCES media(id_media),
    favori BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (utilisateur, id_media, date),

    CHECK (note BETWEEN 0 AND 5),
    CONSTRAINT fk_commente_media FOREIGN KEY (id_media) REFERENCES media(id_media) ON DELETE CASCADE

);

CREATE TABLE participe (
    id_artiste INT REFERENCES artiste(id_artiste) NOT NULL,
    id_media INT REFERENCES media(id_media) NOT NULL,
    id_perso INT REFERENCES personnage(id_perso),
    role VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_artiste, id_media, id_perso, role),
    ON DELETE CASCADE
);

/**
 *	Vues SQL pour les Addendums
**/

-- Pour chaque acteur, le nombre de films de chaque genre dans lesquels il a joué,
-- trié par nombre de films descendant.
CREATE VIEW filmsParActeur AS (
    SELECT a.nom, a.prenom, m.genre, COUNT(*) AS nombreDeFilms
    FROM artiste a
    JOIN participe p ON p.id_artiste = a.id
    JOIN media m ON m.id = p.id_media
    GROUP BY a.nom, a.prenom, m.genre;
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
('deleted-user', 'Supprimé', 'Compte système pour utilisateur supprimé.', 'standard', 'deleted@local', 'Deleted123', '2025-11-24'),
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
