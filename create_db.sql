/**
 *	Holaa, si vous créez une database de toutes pièces en local ou de la même façon qu'en tp,
 * utilisez ce fichier ! Copiez progressivement si vous utilisez  PostgreSql ou faites juste un \i create_db.sql
 * si vous faites sur les ordis de la fac...
 * je galère à créer tout d'un coup à cause des associations, donc j'vais créer les tables et faire des insert après
 * voili voilou
**/

CREATE TABLE genre (
    intitule VARCHAR(50) PRIMARY KEY,
    description TEXT
);

CREATE TABLE artiste (
    id SERIAL PRIMARY KEY,
    nom CHAR(20),
    prenom CHAR(20) NOT NULL,
    role CHAR(20) NOT NULL,
);

CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parution DATE,
    type VARCHAR(50) NOT NULL,
);

CREATE TABLE utilisateur (
    pseudo VARCHAR(20) PRIMARY KEY,
    nom VARCHAR(20),
    biographie TEXT,
    typeDeCompte VARCHAR(20) DEFAULT 'standard',
    mail VARCHAR(255) UNIQUE NOT NULL,
    mdp VARCHAR(100) UNIQUE NOT NULL,
    dateDeCreation DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE personnage (
    id SERIAL PRIMARY KEY,
    nom CHAR(40),
    prenom CHAR(40) NOT NULL,
    description TEXT
);

CREATE TABLE image (
    fichier VARCHAR(50) PRIMARY KEY,
    lien BYTEA,
    alt TEXT
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

ALTER TABLE artiste
ADD COLUMN cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL;

ALTER TABLE media
ADD COLUMN artiste SERIAL REFERENCES artiste(id) NOT NULL;
ALTER TABLE media
ADD COLUMN suite SERIAL REFERENCES media(id);
ALTER TABLE media
ADD COLUMN genre VARCHAR(50) REFERENCES genre(intitule) ;
ALTER TABLE media
ADD COLUMN cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL;

ALTER TABLE utilisateur
ADD COLUMN favori SERIAL REFERENCES media(id);

ALTER TABLE personnage
ADD COLUMN cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL;
ALTER TABLE personnage
ADD COLUMN media SERIAL REFERENCES media(id) NOT NULL;

ALTER TABLE image
ADD COLUMN media SERIAL REFERENCES media(id);
ALTER TABLE image
ADD COLUMN artiste SERIAL REFERENCES artiste(id);
ALTER TABLE image
ADD COLUMN personnage SERIAL REFERENCES personnage(id);
ALTER TABLE image
ADD COLUMN cree_par VARCHAR(20) REFERENCES utilisateur(pseudo) NOT NULL;

-- données
-- 1. Créer l'utilisateur niekitaj (créé aujourd'hui)
INSERT INTO utilisateur (pseudo, nom, biographie, typeDeCompte, mail, mdp, dateDeCreation, favori) 
VALUES ('niekitaj', 'niki', 'Administrateur principal de la plateforme', 'admin', 'niekitaj@example.com', 'hashed_password_123', '2025-11-05', NULL);

-- 2. Créer les genres
INSERT INTO genre (intitule, description) VALUES
('Action', 'Films et séries avec des scènes d''action intenses, combats et cascades'),
('Horreur', 'Œuvres conçues pour effrayer et créer une atmosphère de tension'),
('Psychologique', 'Récits explorant la psyché humaine, les troubles mentaux et les manipulations'),
('Action-Horreur', 'Combinaison d''action intense et d''éléments horrifiques'),
('Thriller Psychologique', 'Suspense basé sur la manipulation mentale et les jeux psychologiques'),
('Horreur Surnaturelle', 'Horreur impliquant des entités paranormales et phénomènes inexpliqués');

-- 3. Créer les artistes (réalisateurs, acteurs, voice actors)
INSERT INTO artiste (nom, prenom, role, cree_par) VALUES
('Nolan', 'Christopher', 'Réalisateur', 'niekitaj'),
('Fincher', 'David', 'Réalisateur', 'niekitaj'),
('Aster', 'Ari', 'Réalisateur', 'niekitaj'),
('DiCaprio', 'Leonardo', 'Acteur', 'niekitaj'),
('Pitt', 'Brad', 'Acteur', 'niekitaj'),
('Collette', 'Toni', 'Actrice', 'niekitaj'),
('Nakamura', 'Yuichi', 'Voice Actor', 'niekitaj'),
('Hayami', 'Saori', 'Voice Actor', 'niekitaj');

-- 4. Créer les médias (films et séries)
INSERT INTO media (titre, description, parution, type, artiste, suite, genre, cree_par) VALUES
('Inception', 'Un voleur spécialisé dans l''extraction de secrets infiltre les rêves pour implanter une idée', '2010-07-16', 'Film', 1, NULL, 'Action', 'niekitaj'),
('Fight Club', 'Un homme insomniaque forme un club de combat clandestin qui échappe à tout contrôle', '1999-10-15', 'Film', 2, NULL, 'Thriller Psychologique', 'niekitaj'),
('Hereditary', 'Une famille est hantée par une présence mystérieuse après la mort de leur grand-mère', '2018-06-08', 'Film', 3, NULL, 'Horreur Surnaturelle', 'niekitaj'),
('The Dark Knight', 'Batman affronte le Joker dans une bataille psychologique pour l''âme de Gotham', '2008-07-18', 'Film', 1, NULL, 'Action', 'niekitaj'),
('Monster', 'Un neurochirurgien traque un ancien patient devenu tueur en série', '2004-04-07', 'Série', 1, NULL, 'Thriller Psychologique', 'niekitaj');

-- 5. Créer les personnages
INSERT INTO personnage (nom, prenom, description, cree_par, media) VALUES
('Cobb', 'Dom', 'Extracteur professionnel hanté par le souvenir de sa femme décédée', 'niekitaj', 3),
('Durden', 'Tyler', 'Personnalité charismatique et anarchiste, alter ego du narrateur', 'niekitaj', 4),
('Graham', 'Annie', 'Mère de famille tourmentée par des secrets familiaux obscurs', 'niekitaj', 5),
('Wayne', 'Bruce', 'Milliardaire philanthrope qui combat le crime sous l''identité de Batman', 'niekitaj', 6),
('Tenma', 'Kenzo', 'Neurochirurgien japonais brillant qui sauve la vie d''un jeune garçon', 'niekitaj', 7),
('Liebert', 'Johan', 'Tueur en série manipulateur aux capacités psychologiques extraordinaires', 'niekitaj', 7);

-- 6. Créer les images (avec données BYTEA simulées)
INSERT INTO image (fichier, lien, alt, media, artiste, personnage, cree_par) VALUES
('inception_poster.jpg', decode('89504E470D0A1A0A0000000D49484452000000...', 'hex'), 'Affiche du film Inception', 1, NULL, NULL, 'niekitaj')


-- 7. Créer les commentaires
INSERT INTO commente (date, texte, note, utilisateur, id_media) VALUES
('2025-11-05', 'Chef-d''œuvre absolu ! La complexité narrative et les effets visuels sont époustouflants.', 10, 'niekitaj', 3),
('2025-11-05', 'Un film qui déconstruit la société de consommation avec brio. Brad Pitt est parfait.', 9, 'niekitaj', 4),
('2025-11-05', 'Film d''horreur psychologique terrifiant. L''ambiance est oppressante du début à la fin.', 9, 'niekitaj', 5),
('2025-11-05', 'Le meilleur film de super-héros jamais réalisé. Heath Ledger est inoubliable en Joker.', 10, 'niekitaj', 6),
('2025-11-05', 'Anime exceptionnel qui explore les limites de la morale humaine. Johan est un antagoniste fascinant.', 10, 'niekitaj', 7);

-- 8. Mettre à jour l'utilisateur avec son média favori
UPDATE utilisateur SET favori = 1 WHERE pseudo = 'niekitaj';
