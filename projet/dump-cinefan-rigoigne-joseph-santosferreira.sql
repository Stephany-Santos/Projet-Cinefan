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
('Action', 'Films et séries avec des scènes d''action intenses, combats et cascades'),
('Horreur', 'Œuvres conçues pour effrayer et créer une atmosphère de tension'),
('Psychologique', 'Récits explorant la psyché humaine, les troubles mentaux et les manipulations'),
('Action-Horreur', 'Combinaison d''action intense et d''éléments horrifiques'),
('Thriller Psychologique', 'Suspense basé sur la manipulation mentale et les jeux psychologiques'),

('Science-Fiction', 'Univers futuristes, technologies avancées et explorations spatiales'),
('Fantasy', 'Mondes imaginaires avec magie, créatures surnaturelles et quêtes héroïques'),
('Comédie', 'Œuvres visant à faire rire par des situations humoristiques ou absurdes'),
('Romance', 'Histoires centrées sur les relations amoureuses et les sentiments'),
('Drame', 'Récits mettant en scène des conflits humains profonds et émotionnels'),

('Aventure', 'Exploration, voyages, péripéties et quêtes épiques'),
('Documentaire', 'Films et séries basés sur des faits réels ou informatifs'),
('Animation', 'Œuvres animées, dessinées ou générées par ordinateur'),
('Policier', 'Enquêtes criminelles, détectives, investigations'),
('Mystère', 'Intrigues basées sur des secrets, énigmes et révélations'),

('Thriller', 'Suspense intense, tension dramatique et retournements de situation'),
('Biographie', 'Récits retraçant la vie de personnalités réelles'),
('Historique', 'Œuvres se déroulant dans des contextes historiques authentiques'),
('Guerre', 'Films et récits centrés sur des conflits armés'),
('Western', 'Histoires se déroulant dans le Far West américain'),

('Cyberpunk', 'Univers dystopiques mêlant technologie avancée et décadence sociale'),
('Steampunk', 'Mondes rétrofuturistes inspirés de la révolution industrielle'),
('Post-Apocalyptique', 'Récits se déroulant après une catastrophe majeure'),
('Super-héros', 'Personnages dotés de pouvoirs extraordinaires'),
('Magie Noire', 'Histoires centrées sur des rituels occultes et forces surnaturelles'),

('Survival', 'Personnages confrontés à des environnements hostiles et à la survie'),
('Zombie', 'Œuvres mettant en scène des créatures non-mortes'),
('Romance Dramatique', 'Relations amoureuses confrontées à des obstacles intenses'),
('Comédie Romantique', 'Mélange de romance et d''humour'),
('Espionnage', 'Intrigues autour d''agents secrets, complots et missions secrètes');


INSERT INTO utilisateur (pseudo, nom, biographie, typeDeCompte, mail, mdp, dateDeCreation)
VALUES
('luna', 'Morel', 'Amatrice de films fantastiques.', 'standard', 'luna.morel@mail.com', 'LunaPass1', '2024-07-14'),
('neo', 'Durand', 'Fan de cyberpunk et d''univers futuristes.', 'créateur', 'neo@techspace.fr', 'NeoSecure55', '2025-01-19'),
('pixelboy', 'Bernard', 'Collectionneur de vieux films.', 'standard', 'pixel.b@mail.com', 'PBmovie99', '2023-12-02'),
('mira', 'Lambert', 'Aime les thrillers sombres.', 'standard', 'mira.lambert@mail.fr', 'MiraPwd2024', '2024-04-09'),
('jasmin', 'Petit', 'Blogueuse cinéma.', 'créateur', 'jasmin@blog.fr', 'JasminFilm*1', '2024-11-18'),

('shadowfox', 'Robert', 'Fan de films d''espionnage.', 'standard', 'shadow@movie.net', 'Shadow123', '2025-02-07'),
('akira', 'Nguyen', 'Passionné d''animation japonaise.', 'standard', 'akira.nguyen@mail.com', 'AkiR4!', '2023-10-26'),
('eliora', 'Roux', 'Apprécie les dramas historiques.', 'standard', 'eliora.roux@mail.fr', 'ElioraPwd', '2024-08-21'),
('toma', 'Diallo', 'Monte des critiques vidéos.', 'créateur', 'toma@video.fr', 'DialloVid22', '2025-06-03'),
('skylie', 'Marchand', 'Grande fan de comédies romantiques.', 'standard', 'skylie@mail.com', 'SkyLove2023', '2023-05-17'),

('delta', 'Fischer', 'Modérateur bénévole passionné.', 'modérateur', 'delta@admin.org', 'DeltaMod44', '2025-03-29'),
('ghost', 'Fabre', 'Aime les films d''horreur.', 'standard', 'ghost@horror.fr', 'Gh0st*H', '2024-09-12'),
('ragnar', 'Hubert', 'Passionné d''épopées vikings.', 'standard', 'ragnar@mail.com', 'Ragn4r!', '2024-07-02'),
('sybel', 'Barbier', 'Autrice de critiques courtes.', 'créateur', 'sybel@critics.fr', 'SybelCritik', '2025-10-10'),
('mattix', 'Garnier', 'Cinéphile depuis l’enfance.', 'standard', 'mattix.g@mail.com', 'Mattix88', '2024-02-21'),

('tenshi', 'Lopez', 'Fascinée par les films psychologiques.', 'standard', 'tenshi@mail.net', 'TenshiLock', '2025-01-05'),
('kronos', 'Bouvier', 'Spécialiste films temporels.', 'créateur', 'kronos@time.fr', 'KronoS*12', '2025-04-14'),
('liv', 'Pires', 'Aime les documentaires animaliers.', 'standard', 'liv.pires@mail.com', 'LivDoc2024', '2024-03-03'),
('mecha', 'Schmitt', 'Fan de robots géants et SF.', 'standard', 'mecha.sf@mail.com', 'Mecha22', '2023-08-09'),
('eve93', 'Meyer', 'Regarde beaucoup de biopics.', 'standard', 'eve93@mail.fr', 'EvePass', '2024-06-18'),

('solaris', 'Andrieu', 'Passionné d''astronomie et de films spatiaux.', 'standard', 'solaris@astro.fr', 'Solar_2023', '2023-10-13'),
('tigra', 'Colin', 'Aime les films d''aventure.', 'standard', 'tigra@mail.com', 'TigraClaws', '2024-11-06'),
('noctis', 'Giraud', 'Fan de films noirs.', 'standard', 'noctis@mail.net', 'N0ct1s', '2025-08-26'),
('cass', 'Baron', 'Critique de films indépendants.', 'créateur', 'cass@indie.fr', 'CassInd44', '2024-01-11'),
('echo', 'Rolland', 'Collectionne les OST de films.', 'standard', 'echo.music@mail.com', 'EchoMusik', '2023-09-04'),

('iris_bl', 'Blanc', 'Adore les films romantiques italiens.', 'standard', 'iris@mail.com', 'IrisPwd', '2024-02-27'),
('tango', 'Lefevre', 'Passionné de westerns.', 'standard', 'tango@cowboy.fr', 'TangoRide', '2024-05-15'),
('nova', 'Gillet', 'Suit beaucoup l''actualité cinéma.', 'modérateur', 'nova@admin.fr', 'NovaAdm**', '2025-03-01'),
('ariel', 'Delcourt', 'Étudiante en cinéma.', 'standard', 'ariel.dc@mail.com', 'Ariel2024', '2024-07-08'),
('prism', 'Pellier', 'Aime les couleurs et l''esthétique visuelle.', 'standard', 'prism@mail.net', 'Prism88', '2025-10-20'),

('rosetta', 'Brunet', 'Fan de films historiques.', 'standard', 'rosetta@mail.com', 'RosettaPwd', '2023-11-11'),
('omega', 'Jacquet', 'Adore les scénarios complexes.', 'créateur', 'omega@stories.fr', 'Om3gA12', '2025-09-09'),
('silvio', 'Marais', 'Passionné d''opéra et de comédies musicales.', 'standard', 'silvio@mail.com', 'SilvioPwd', '2024-04-26'),
('kaya', 'Hoarau', 'Grande consommatrice de séries.', 'standard', 'kaya@series.fr', 'KayaLove', '2023-12-28'),
('tomaX', 'Guillon', 'Adepte du cinéma d''auteur.', 'standard', 'tomax@mail.com', 'Tomax77', '2024-03-23'),

('lux', 'Poirier', 'Aime les films lumineux et poétiques.', 'standard', 'lux@mail.net', 'LuxLite', '2024-09-30'),
('hazel', 'Bernier', 'Intéressée par les documentaires scientifiques.', 'standard', 'hazel@doc.fr', 'HazelDoc', '2023-06-17'),
('marlow', 'Schneider', 'Passionné de thrillers juridiques.', 'standard', 'marlow@mail.com', 'Marlow123', '2025-02-28'),
('gaia', 'Pasquier', 'Aime les films nature & écologie.', 'standard', 'gaia@mail.com', 'GaiaGreen', '2024-10-03'),
('vortex', 'Paris', 'Fan d''effets spéciaux.', 'créateur', 'vortex@fx.fr', 'V0rtex*FX', '2025-04-30'),

('serena', 'Benali', 'Regarde surtout des drames sociaux.', 'standard', 'serena@mail.fr', 'SerenaPwd', '2024-08-05'),
('atlas', 'Delmas', 'Passionné de films épiques.', 'standard', 'atlas@mail.com', 'Atlas2025', '2025-06-14'),
('julian', 'Lacombe', 'Aime les bandes-annonces et trailers.', 'standard', 'julian@trailer.fr', 'JulianT', '2023-07-29'),
('crystal', 'Gomes', 'Très active sur les critiques de séries.', 'créateur', 'crystal@mail.com', 'CryStal*', '2025-05-18'),
('tempo', 'Ollier', 'Fan de films musicaux et choraux.', 'standard', 'tempo@mail.net', 'Temp0Beat', '2024-01-31');

INSERT INTO artiste (nom, prenom, role, cree_par)
VALUES
('Spielberg', 'Steven', 'réalisateur', 'alice'),
('Durand', 'Sophie', 'actrice', 'bob42'),
('Smith', 'John', 'doubleur', 'charly'),
('Lambert', 'Claire', 'actrice', 'luna'),
('Moreau', 'Julien', 'réalisateur', 'neo'),
('Petit', 'Emma', 'doubleuse', 'pixelboy'),
('Bernard', 'Lucas', 'acteur', 'mira'),
('Schmidt', 'Anna', 'réalisatrice', 'jasmin'),

('Rossi', 'Marco', 'acteur', 'shadowfox'),
('Nguyen', 'Thierry', 'doubleur', 'akira'),
('Lemoine', 'Camille', 'actrice', 'eliora'),
('Diallo', 'Moussa', 'acteur', 'toma'),
('Marchand', 'Zoé', 'réalisatrice', 'skylie'),

('Fischer', 'Nils', 'acteur', 'delta'),
('Fabre', 'Nora', 'actrice', 'ghost'),
('Hubert', 'Victor', 'réalisateur', 'ragnar'),
('Barbier', 'Sarah', 'doubleuse', 'sybel'),
('Garnier', 'Louis', 'acteur', 'mattix'),

('Lopez', 'Inès', 'actrice', 'tenshi'),
('Bouvier', 'Alain', 'réalisateur', 'kronos'),
('Pires', 'Mila', 'actrice', 'liv'),
('Schmitt', 'Ethan', 'acteur', 'mecha'),
('Meyer', 'Laura', 'doubleuse', 'eve93'),

('Andrieu', 'Simon', 'réalisateur', 'solaris'),
('Colin', 'Justine', 'actrice', 'tigra'),
('Giraud', 'Axel', 'acteur', 'noctis'),
('Baron', 'Nina', 'doubleuse', 'cass'),
('Rolland', 'Jonas', 'acteur', 'echo'),

('Blanc', 'Léa', 'actrice', 'iris_bl'),
('Lefevre', 'Renaud', 'réalisateur', 'tango'),
('Gillet', 'Mélina', 'doubleuse', 'nova'),
('Delcourt', 'Arthur', 'acteur', 'ariel'),
('Pellier', 'Sasha', 'actrice', 'prism'),

('Brunet', 'Maëlle', 'actrice', 'rosetta'),
('Jacquet', 'Hugo', 'réalisateur', 'omega'),
('Marais', 'Sandro', 'acteur', 'silvio'),
('Hoarau', 'Selma', 'doubleuse', 'kaya'),
('Guillon', 'Théo', 'acteur', 'tomaX'),

('Poirier', 'Alice', 'actrice', 'lux'),
('Bernier', 'Clara', 'doubleuse', 'hazel'),
('Schneider', 'Romain', 'acteur', 'marlow'),
('Pasquier', 'Léonie', 'actrice', 'gaia'),
('Paris', 'Yanis', 'réalisateur', 'vortex'),

('Benali', 'Imène', 'actrice', 'serena'),
('Delmas', 'Oscar', 'acteur', 'atlas'),
('Lacombe', 'Julie', 'doubleuse', 'julian'),
('Gomes', 'Andrea', 'réalisatrice', 'crystal'),
('Ollier', 'Mathis', 'acteur', 'tempo'),

('Martin', 'Éva', 'actrice', 'luna'),
('Morel', 'Stéphane', 'réalisateur', 'neo'),
('Durand', 'Meline', 'actrice', 'pixelboy'),
('Ribeiro', 'Paulo', 'acteur', 'mira'),
('Fontaine', 'Louise', 'doubleuse', 'jasmin'),

('Chevalier', 'Damien', 'acteur', 'shadowfox'),
('Dumas', 'Aurore', 'actrice', 'akira'),
('Keller', 'Rémi', 'réalisateur', 'eliora'),
('Bourdon', 'Ivana', 'actrice', 'toma'),
('Aubert', 'Nolan', 'acteur', 'skylie'),

('Thierry', 'Myriam', 'doubleuse', 'delta'),
('Leblanc', 'Quentin', 'acteur', 'ghost'),
('Renaud', 'Elise', 'actrice', 'ragnar'),
('Poulain', 'Jonas', 'réalisateur', 'sybel'),
('Haddad', 'Sonia', 'doubleuse', 'mattix'),

('Levy', 'Marc', 'acteur', 'tenshi'),
('Garcia', 'Mila', 'actrice', 'kronos'),
('Bodin', 'Adrien', 'réalisateur', 'liv'),
('Charpentier', 'Lucy', 'actrice', 'mecha'),
('Renard', 'Paul', 'acteur', 'eve93'),

('Caron', 'Isabelle', 'doubleuse', 'solaris'),
('Lagarde', 'Maxime', 'acteur', 'tigra'),
('Navarro', 'Lina', 'actrice', 'noctis'),
('Gilbert', 'Victor', 'réalisateur', 'cass'),
('Ory', 'Élodie', 'actrice', 'echo'),

('Picard', 'Sam', 'acteur', 'iris_bl'),
('Delaunay', 'Morgane', 'actrice', 'tango'),
('Brisset', 'Kevin', 'réalisateur', 'nova'),
('Hardy', 'Nadia', 'actrice', 'ariel'),
('Giraudet', 'Maud', 'doubleuse', 'prism');

-- ids générés : 1, 2, 3

INSERT INTO media (titre, description, parution, type, realise, suite, genre, cree_par)
VALUES

('Voyage Stellaire', 'Un équipage se lance dans l''espace.', '2023-03-01', 'film', 1, NULL, 'Science-fiction', 'alice'),
('Le Royaume Caché', 'Un jeune garçon découvre un monde secret.', '2022-10-15', 'film', 1, NULL, 'Aventure', 'bob42'),
('Animaliens', 'Une planète habitée par des animaux animés.', '2024-04-20', 'série', 1, NULL, 'Animation', 'charly'),
('CyberNet', 'Un hacker lutte contre une IA malveillante.', '2023-06-11', 'film', 2, NULL, 'Cyberpunk', 'neo'),
('L''Énigme du Temps', 'Un détective résout des mystères temporels.', '2024-02-18', 'film', 3, NULL, 'Thriller', 'pixelboy'),
('Les Ombres de Minuit', 'Des événements étranges surviennent dans une ville.', '2023-09-05', 'série', 4, NULL, 'Horreur', 'mira'),
('La Quête du Dragon', 'Un héros part affronter un dragon légendaire.', '2023-12-20', 'film', 5, NULL, 'Fantasy', 'jasmin'),
('Galaxy Riders', 'Course poursuite dans des vaisseaux spatiaux.', '2024-05-07', 'film', 6, NULL, 'Action', 'shadowfox'),
('La Magie Perdue', 'Un magicien tente de retrouver ses pouvoirs.', '2024-07-21', 'série', 7, NULL, 'Fantasy', 'akira'),
('Nuit de Terreur', 'Une maison hantée met en danger ses habitants.', '2023-10-31', 'film', 8, NULL, 'Horreur', 'eliora'),
('Code Omega', 'Des espions s''affrontent pour un microfilm secret.', '2025-01-15', 'film', 9, NULL, 'Espionnage', 'toma'),
('L''Île Mystérieuse', 'Un groupe échoué sur une île étrange.', '2023-08-12', 'film', 10, NULL, 'Aventure', 'skylie'),
('Animaux Extraordinaires', 'Des animaux avec des pouvoirs magiques.', '2023-11-03', 'série', 11, NULL, 'Animation', 'delta'),
('Le Labyrinthe Mental', 'Un thriller psychologique captivant.', '2024-03-19', 'film', 12, NULL, 'Psychologique', 'ghost'),
('Les Chroniques du Futur', 'Une société futuriste confrontée à une rébellion.', '2025-06-28', 'série', 13, NULL, 'Science-fiction', 'ragnar'),
('Échos de la Nuit', 'Une enquête mystérieuse dans une ville sombre.', '2024-09-14', 'film', 14, NULL, 'Mystère', 'sybel'),
('Le Royaume Englouti', 'Un royaume sous-marin plein de secrets.', '2023-07-25', 'film', 15, NULL, 'Fantasy', 'mattix'),
('Dernière Évasion', 'Un prisonnier tente de s''évader d''une forteresse.', '2023-05-09', 'film', 16, NULL, 'Action', 'tenshi'),
('Rêves Brisés', 'Des vies entrecroisées dans une grande ville.', '2024-12-02', 'série', 17, NULL, 'Drame', 'kronos'),
('Star Raiders', 'Une guerre intergalactique oppose deux factions.', '2025-02-20', 'film', 18, NULL, 'Science-fiction', 'liv'),

('Les Chroniques de l''Ombre', 'Un héros lutte contre les forces du mal.', '2023-06-30', 'film', 19, NULL, 'Fantasy', 'mecha'),
('L''Assassin Masqué', 'Un détective traque un mystérieux assassin.', '2024-01-10', 'série', 20, NULL, 'Policier', 'eve93'),
('Robotica', 'Des robots prennent le contrôle de la ville.', '2023-09-27', 'film', 21, NULL, 'Science-fiction', 'solaris'),
('Le Secret du Pharaon', 'Une aventure dans l''Égypte antique.', '2024-04-05', 'film', 22, NULL, 'Aventure', 'tigra'),
('Âmes Perdues', 'Des esprits hantent un vieux manoir.', '2025-03-31', 'série', 23, NULL, 'Horreur', 'noctis'),
('L''Étoile Filante', 'Une quête pour sauver la galaxie.', '2024-07-18', 'film', 24, NULL, 'Science-fiction', 'cass'),
('Les Mystères de l''Esprit', 'Un thriller sur la manipulation mentale.', '2023-11-22', 'film', 25, NULL, 'Thriller Psychologique', 'echo'),
('Animapolis', 'Une ville peuplée d''animaux intelligents.', '2025-05-05', 'série', 26, NULL, 'Animation', 'iris_bl'),
('Le Dernier Chevalier', 'Un héros se bat pour sauver son royaume.', '2023-08-14', 'film', 27, NULL, 'Action', 'tango'),
('Cyber Wars', 'Des hackers et mercenaires s''affrontent.', '2024-06-09', 'film', 28, NULL, 'Action', 'nova'),

('Magie Interdite', 'Une magie ancienne menace le monde.', '2023-09-20', 'film', 29, NULL, 'Fantasy', 'ariel'),
('Le Voyageur du Temps', 'Un scientifique voyage à travers le temps.', '2025-01-02', 'série', 30, NULL, 'Science-fiction', 'prism'),
('Le Masque du Destin', 'Des complots et trahisons dans un royaume.', '2024-03-15', 'film', 31, NULL, 'Aventure', 'rosetta'),
('Zombie Apocalypse', 'Les survivants luttent contre les morts-vivants.', '2023-10-10', 'série', 32, NULL, 'Zombie', 'omega'),
('Les Héritiers', 'Une famille découvre un secret ancestral.', '2024-11-28', 'film', 33, NULL, 'Drame', 'silvio'),
('Chroniques Spatiales', 'Explorateurs découvrent de nouvelles planètes.', '2025-04-16', 'série', 34, NULL, 'Science-fiction', 'kaya'),
('Les Cavaliers de l''Aube', 'Un royaume menacé par une invasion.', '2023-07-11', 'film', 35, NULL, 'Action', 'tomaX'),
('Le Jardin Secret', 'Un enfant découvre un jardin magique.', '2024-05-21', 'film', 36, NULL, 'Fantasy', 'lux'),
('La Nuit des Fantômes', 'Une enquête paranormale dans une maison abandonnée.', '2023-12-19', 'série', 37, NULL, 'Horreur', 'hazel'),
('Le Pouvoir Caché', 'Un adolescent découvre ses pouvoirs extraordinaires.', '2025-02-27', 'film', 38, NULL, 'Fantasy', 'marlow'),

('Expédition Infernale', 'Une mission périlleuse dans les volcans.', '2024-03-08', 'film', 39, NULL, 'Aventure', 'gaia'),
('Rêves et Cauchemars', 'Une série où réalité et illusions se confondent.', '2023-08-25', 'série', 40, NULL, 'Psychologique', 'vortex'),
('Supernova', 'Une guerre galactique éclate autour d''une étoile.', '2025-06-12', 'film', 41, NULL, 'Science-fiction', 'serena'),
('L''Île des Secrets', 'Des adolescents explorent une île mystérieuse.', '2023-09-01', 'série', 42, NULL, 'Aventure', 'atlas'),
('Les Maîtres du Temps', 'Des voyageurs du temps modifient l''histoire.', '2024-10-17', 'film', 43, NULL, 'Science-fiction', 'julian'),
('Créatures Nocturnes', 'Des monstres attaquent une ville la nuit.', '2025-03-05', 'série', 44, NULL, 'Horreur', 'crystal'),
('L''Art de la Guerre', 'Stratégies et batailles épiques.', '2023-07-28', 'film', 45, NULL, 'Action', 'tempo'),
('Rêverie', 'Une série poétique sur la vie et l''amour.', '2024-06-14', 'série', 46, NULL, 'Drame', 'luna'),
('La Légende du Phénix', 'Une quête pour réveiller un oiseau légendaire.', '2023-11-30', 'film', 47, NULL, 'Fantasy', 'neo'),
('Les Ombres du Passé', 'Secrets et trahisons dans une famille.', '2024-04-02', 'série', 48, NULL, 'Thriller', 'pixelboy');

-- ids générés : 1, 2, 3

INSERT INTO personnage (nom, prenom, description, cree_par, media)
VALUES

('Stone', 'Elena', 'Capitaine du vaisseau', 'alice', 1),
('Martin', 'Lucas', 'Héros du royaume caché', 'bob42', 2),
('Tigrou', 'Maxwell', 'Tigre doué de parole', 'charly', 3),
('Roux', 'Clara', 'Magicienne de la forêt', 'luna', 4),
('Durand', 'Théo', 'Jeune détective', 'neo', 5),
('Petit', 'Emma', 'Animalière courageuse', 'pixelboy', 6),
('Bernard', 'Louis', 'Capitaine rebelle', 'mira', 7),
('Schmitt', 'Anna', 'Sorcière mystérieuse', 'jasmin', 8),
('Rossi', 'Marco', 'Guerrier intergalactique', 'shadowfox', 9),
('Nguyen', 'Thierry', 'Inventeur fou', 'akira', 10),

('Lemoine', 'Camille', 'Princesse en danger', 'eliora', 11),
('Diallo', 'Moussa', 'Pilote intrépide', 'toma', 12),
('Marchand', 'Zoé', 'Créature magique', 'skylie', 13),
('Fischer', 'Nils', 'Chef de la résistance', 'delta', 14),
('Fabre', 'Nora', 'Fantôme vengeur', 'ghost', 15),
('Hubert', 'Victor', 'Détective légendaire', 'ragnar', 16),
('Barbier', 'Sarah', 'Esprit malin', 'sybel', 17),
('Garnier', 'Louis', 'Explorateur audacieux', 'mattix', 18),
('Lopez', 'Inès', 'Reine des elfes', 'tenshi', 19),
('Bouvier', 'Alain', 'Scientifique brillant', 'kronos', 20),

('Pires', 'Mila', 'Animal parlant', 'liv', 21),
('Schneider', 'Romain', 'Héros tragique', 'mecha', 22),
('Pasquier', 'Léonie', 'Sorcière noire', 'eve93', 23),
('Paris', 'Yanis', 'Chevalier courageux', 'solaris', 24),
('Benali', 'Imène', 'Espionne habile', 'tigra', 25),
('Delmas', 'Oscar', 'Prince du royaume', 'noctis', 26),
('Lacombe', 'Julie', 'Déesse protectrice', 'cass', 27),
('Gomes', 'Andrea', 'Pilote de vaisseau', 'echo', 28),
('Ollier', 'Mathis', 'Chasseur de trésors', 'iris_bl', 29),
('Martin', 'Éva', 'Soldat d''élite', 'tango', 30),

('Morel', 'Stéphane', 'Alchimiste', 'nova', 31),
('Durand', 'Meline', 'Exploratrice courageuse', 'ariel', 32),
('Ribeiro', 'Paulo', 'Robot intelligent', 'prism', 33),
('Fontaine', 'Louise', 'Princesse pirate', 'rosetta', 34),
('Chevalier', 'Damien', 'Sorcier ancien', 'omega', 35),
('Dumas', 'Aurore', 'Guerrière légendaire', 'silvio', 36),
('Keller', 'Rémi', 'Espion masqué', 'kaya', 37),
('Bourdon', 'Ivana', 'Créature féerique', 'tomaX', 38),
('Aubert', 'Nolan', 'Capitaine intrépide', 'lux', 39),
('Thierry', 'Myriam', 'Scientifique du futur', 'hazel', 40),

('Leblanc', 'Quentin', 'Héros du peuple', 'marlow', 41),
('Renaud', 'Elise', 'Princesse perdue', 'gaia', 42),
('Poulain', 'Jonas', 'Fantôme de la forêt', 'vortex', 43),
('Haddad', 'Sonia', 'Chevalier noir', 'serena', 44),
('Levy', 'Marc', 'Inventeur excentrique', 'atlas', 45),
('Garcia', 'Mila', 'Magicienne du temps', 'julian', 46),
('Bodin', 'Adrien', 'Héros spatial', 'crystal', 47),
('Charpentier', 'Lucy', 'Créature magique', 'tempo', 48),
('Renard', 'Paul', 'Espion intergalactique', 'luna', 49),
('Caron', 'Isabelle', 'Reine d''un royaume perdu', 'neo', 50),

('Lagarde', 'Maxime', 'Guerrier rebelle', 'pixelboy', 51),
('Navarro', 'Lina', 'Sorcière bienveillante', 'mira', 52),
('Gilbert', 'Victor', 'Détective du futur', 'jasmin', 53),
('Ory', 'Élodie', 'Chasseur de monstres', 'shadowfox', 54),
('Picard', 'Sam', 'Explorateur spatial', 'akira', 55),
('Delaunay', 'Morgane', 'Héros mythologique', 'eliora', 56),
('Brisset', 'Kevin', 'Robot militaire', 'toma', 57),
('Hardy', 'Nadia', 'Princesse rebelle', 'skylie', 58),
('Giraudet', 'Maud', 'Sorcière des ténèbres', 'delta', 59),
('Stone', 'Léo', 'Capitaine de l''équipage', 'ghost', 60),

('Martin', 'Clémence', 'Espionne du royaume', 'ragnar', 61),
('Tigrou', 'Sammy', 'Compagnon animalier', 'sybel', 62),
('Roux', 'Julien', 'Chevalier du futur', 'mattix', 63),
('Durand', 'Sophie', 'Magicienne expérimentée', 'tenshi', 64),
('Petit', 'Lucie', 'Héroïne courageuse', 'kronos', 65),
('Bernard', 'Max', 'Pilote audacieux', 'liv', 66),
('Schmitt', 'Élise', 'Princesse intrépide', 'mecha', 67),
('Rossi', 'Nina', 'Espionne mystérieuse', 'eve93', 68),
('Nguyen', 'Leo', 'Inventeur du futur', 'solaris', 69),
('Lemoine', 'Zoé', 'Guerrière légendaire', 'tigra', 70),

('Diallo', 'Amira', 'Héroïne magique', 'noctis', 71),
('Marchand', 'Lucas', 'Capitaine courageux', 'cass', 72),
('Fischer', 'Clara', 'Sorcière de la forêt', 'echo', 73),
('Fabre', 'Thomas', 'Explorateur légendaire', 'iris_bl', 74),
('Hubert', 'Alice', 'Héroïne spatiale', 'tango', 75),
('Barbier', 'Hugo', 'Chevalier du royaume', 'nova', 76),
('Garnier', 'Mila', 'Scientifique brillante', 'ariel', 77),
('Lopez', 'Maxime', 'Magicien du temps', 'prism', 78),
('Bouvier', 'Léa', 'Princesse courageuse', 'rosetta', 79),
('Pires', 'Mathis', 'Robot intelligent', 'omega', 80),

('Schneider', 'Clara', 'Capitaine rebelle', 'silvio', 81),
('Pasquier', 'Lucas', 'Héros tragique', 'kaya', 82),
('Paris', 'Mila', 'Sorcière bienveillante', 'tomaX', 83),
('Benali', 'Julien', 'Explorateur courageux', 'lux', 84),
('Delmas', 'Emma', 'Princesse intrépide', 'hazel', 85),
('Lacombe', 'Noah', 'Inventeur fou', 'marlow', 86),
('Gomes', 'Clara', 'Héroïne magique', 'gaia', 87),
('Ollier', 'Théo', 'Chevalier du futur', 'vortex', 88),
('Martin', 'Alice', 'Sorcière des ténèbres', 'serena', 89),
('Morel', 'Lucas', 'Capitaine de l''équipage', 'atlas', 90),

('Durand', 'Emma', 'Espionne intrépide', 'julian', 91),
('Ribeiro', 'Leo', 'Pilote audacieux', 'crystal', 92),
('Fontaine', 'Sofia', 'Princesse courageuse', 'tempo', 93),
('Chevalier', 'Nolan', 'Héros légendaire', 'luna', 94),
('Dumas', 'Léa', 'Sorcière mystérieuse', 'neo', 95),
('Keller', 'Théo', 'Guerrier intergalactique', 'pixelboy', 96),
('Bourdon', 'Emma', 'Animalière courageuse', 'mira', 97),
('Aubert', 'Lucas', 'Capitaine rebelle', 'jasmin', 98),
('Thierry', 'Clara', 'Héroïne du royaume', 'shadowfox', 99),
('Leblanc', 'Maxime', 'Explorateur spatial', 'akira', 100);

-- ids générés : 1, 2, 3

INSERT INTO image (fichier, lien, alt, media, artiste, personnage, cree_par)
VALUES

('vs_affiche.jpg', NULL, 'Affiche du film Voyage Stellaire', 1, NULL, NULL, 'alice'),
('tgr_maxwell.png', NULL, 'Portrait du personnage Tigrou Maxwell', 3, 3, 3, 'charly'),
('lrk_affiche.jpg', NULL, 'Affiche Le Royaume Caché', 2, NULL, NULL, 'bob42'),
('cybernet_poster.jpg', NULL, 'Affiche CyberNet', 4, NULL, NULL, 'neo'),
('enigme_temps.png', NULL, 'Affiche L''Énigme du Temps', 5, NULL, NULL, 'pixelboy'),
('ombres_minuit.jpg', NULL, 'Affiche Les Ombres de Minuit', 6, NULL, NULL, 'mira'),
('quete_dragon.png', NULL, 'Affiche La Quête du Dragon', 7, NULL, NULL, 'jasmin'),
('galaxy_riders.jpg', NULL, 'Affiche Galaxy Riders', 8, NULL, NULL, 'shadowfox'),
('magie_perdue.png', NULL, 'Affiche La Magie Perdue', 9, NULL, NULL, 'akira'),
('nuit_terreur.jpg', NULL, 'Affiche Nuit de Terreur', 10, NULL, NULL, 'eliora'),

('code_omega.png', NULL, 'Affiche Code Omega', 11, NULL, NULL, 'toma'),
('ile_mysterieuse.jpg', NULL, 'Affiche L''Île Mystérieuse', 12, NULL, NULL, 'skylie'),
('animaux_extraordinaires.png', NULL, 'Affiche Animaux Extraordinaires', 13, NULL, NULL, 'delta'),
('labyrinthe_mental.jpg', NULL, 'Affiche Le Labyrinthe Mental', 14, NULL, NULL, 'ghost'),
('chroniques_futur.png', NULL, 'Affiche Les Chroniques du Futur', 15, NULL, NULL, 'ragnar'),
('echos_nuit.jpg', NULL, 'Affiche Échos de la Nuit', 16, NULL, NULL, 'sybel'),
('royaume_englouti.png', NULL, 'Affiche Le Royaume Englouti', 17, NULL, NULL, 'mattix'),
('derniere_evasion.jpg', NULL, 'Affiche Dernière Évasion', 18, NULL, NULL, 'tenshi'),
('reves_bries.png', NULL, 'Affiche Rêves Brisés', 19, NULL, NULL, 'kronos'),
('star_raiders.jpg', NULL, 'Affiche Star Raiders', 20, NULL, NULL, 'liv'),

('chroniques_ombre.png', NULL, 'Affiche Les Chroniques de l''Ombre', 21, NULL, NULL, 'mecha'),
('assassin_masque.jpg', NULL, 'Affiche L''Assassin Masqué', 22, NULL, NULL, 'eve93'),
('robotica.png', NULL, 'Affiche Robotica', 23, NULL, NULL, 'solaris'),
('secret_pharaon.jpg', NULL, 'Affiche Le Secret du Pharaon', 24, NULL, NULL, 'tigra'),
('ames_perdues.png', NULL, 'Affiche Âmes Perdues', 25, NULL, NULL, 'noctis'),
('etoile_filante.jpg', NULL, 'Affiche L''Étoile Filante', 26, NULL, NULL, 'cass'),
('mysteres_esprit.png', NULL, 'Affiche Les Mystères de l''Esprit', 27, NULL, NULL, 'echo'),
('animapolis.jpg', NULL, 'Affiche Animapolis', 28, NULL, NULL, 'iris_bl'),
('dernier_chevalier.png', NULL, 'Affiche Le Dernier Chevalier', 29, NULL, NULL, 'tango'),
('cyber_wars.jpg', NULL, 'Affiche Cyber Wars', 30, NULL, NULL, 'nova'),

('magie_interdite.png', NULL, 'Affiche Magie Interdite', 31, NULL, NULL, 'ariel'),
('voyageur_temps.jpg', NULL, 'Affiche Le Voyageur du Temps', 32, NULL, NULL, 'prism'),
('masque_destin.png', NULL, 'Affiche Le Masque du Destin', 33, NULL, NULL, 'rosetta'),
('zombie_apocalypse.jpg', NULL, 'Affiche Zombie Apocalypse', 34, NULL, NULL, 'omega'),
('les_heritiers.png', NULL, 'Affiche Les Héritiers', 35, NULL, NULL, 'silvio'),
('chroniques_spatiales.jpg', NULL, 'Affiche Chroniques Spatiales', 36, NULL, NULL, 'kaya'),
('cavaliers_aube.png', NULL, 'Affiche Les Cavaliers de l''Aube', 37, NULL, NULL, 'tomaX'),
('jardin_secret.jpg', NULL, 'Affiche Le Jardin Secret', 38, NULL, NULL, 'lux'),
('nuit_fantomes.png', NULL, 'Affiche La Nuit des Fantômes', 39, NULL, NULL, 'hazel'),
('pouvoir_cache.jpg', NULL, 'Affiche Le Pouvoir Caché', 40, NULL, NULL, 'marlow'),

('expedition_infernale.png', NULL, 'Affiche Expédition Infernale', 41, NULL, NULL, 'gaia'),
('reves_cauchemars.jpg', NULL, 'Affiche Rêves et Cauchemars', 42, NULL, NULL, 'vortex'),
('supernova.png', NULL, 'Affiche Supernova', 43, NULL, NULL, 'serena'),
('ile_secrets.jpg', NULL, 'Affiche L''Île des Secrets', 44, NULL, NULL, 'atlas'),
('maitres_temps.png', NULL, 'Affiche Les Maîtres du Temps', 45, NULL, NULL, 'julian'),
('creatures_nocturnes.jpg', NULL, 'Affiche Créatures Nocturnes', 46, NULL, NULL, 'crystal'),
('art_guerre.png', NULL, 'Affiche L''Art de la Guerre', 47, NULL, NULL, 'tempo'),
('reverie.jpg', NULL, 'Affiche Rêverie', 48, NULL, NULL, 'luna'),
('legende_phenix.png', NULL, 'Affiche La Légende du Phénix', 49, NULL, NULL, 'neo'),
('ombres_passe.jpg', NULL, 'Affiche Les Ombres du Passé', 50, NULL, NULL, 'pixelboy');


INSERT INTO commente (date, texte, note, utilisateur, id_media)
VALUES

('2025-10-10', 'Très beau film, concept original !', 9, 'bob42', 1),
('2025-11-01', 'Décors superbes, manque d''action', 7, 'alice', 2),
('2025-11-11', 'Animation bluffante', 8, 'charly', 3),
('2025-03-15', 'Scénario captivant, acteurs parfaits', 9, 'luna', 4),
('2024-12-20', 'Un peu long mais agréable', 7, 'neo', 5),
('2025-01-08', 'Suspense bien maintenu', 8, 'pixelboy', 6),
('2024-06-14', 'Trop prévisible', 5, 'mira', 7),
('2025-09-02', 'Effets spéciaux impressionnants', 9, 'jasmin', 8),
('2024-08-23', 'Très drôle et inventif', 8, 'shadowfox', 9),
('2025-02-17', 'Histoire originale, à voir', 8, 'akira', 10),

('2024-07-30', 'Des scènes un peu violentes', 6, 'eliora', 11),
('2025-05-12', 'Musique excellente', 9, 'toma', 12),
('2025-06-18', 'Personnages attachants', 8, 'skylie', 13),
('2025-03-25', 'Intrigue fascinante', 9, 'delta', 14),
('2025-04-10', 'Un peu confus par moments', 6, 'ghost', 15),
('2025-08-01', 'Très bonne réalisation', 9, 'ragnar', 16),
('2024-11-05', 'Histoire trop rapide', 6, 'sybel', 17),
('2025-09-20', 'Magie et aventures réussies', 8, 'mattix', 18),
('2025-02-28', 'Acteurs convaincants', 8, 'tenshi', 19),
('2025-07-14', 'Rythme un peu lent', 6, 'kronos', 20),

('2025-03-02', 'Idée originale mais mal exploitée', 5, 'liv', 21),
('2025-06-05', 'Graphismes incroyables', 9, 'mecha', 22),
('2024-09-17', 'Scénario intéressant', 8, 'eve93', 23),
('2025-01-25', 'Trop prévisible', 5, 'solaris', 24),
('2025-08-10', 'Horreur efficace', 8, 'tigra', 25),
('2025-09-30', 'Émotions au rendez-vous', 9, 'noctis', 26),
('2025-04-20', 'Suspense moyen', 6, 'cass', 27),
('2024-12-12', 'Animation superbe', 9, 'echo', 28),
('2025-05-18', 'Bonne intrigue', 8, 'iris_bl', 29),
('2025-02-05', 'Trop d''effets spéciaux', 5, 'tango', 30),

('2025-06-22', 'Très divertissant', 9, 'nova', 31),
('2025-08-15', 'Acteurs peu convaincants', 5, 'ariel', 32),
('2025-01-30', 'Aventure réussie', 8, 'prism', 33),
('2025-07-19', 'Scénario original', 8, 'rosetta', 34),
('2024-10-25', 'Trop gore pour moi', 4, 'omega', 35),
('2025-03-11', 'Très émouvant', 9, 'silvio', 36),
('2025-05-22', 'Intrigue captivante', 8, 'kaya', 37),
('2025-02-14', 'Un peu long', 6, 'tomaX', 38),
('2025-06-28', 'Animation magnifique', 9, 'lux', 39),
('2025-09-08', 'Bonne idée mais réalisation moyenne', 7, 'hazel', 40),

('2025-01-05', 'Rythme parfait', 9, 'marlow', 41),
('2025-03-22', 'Histoire originale', 8, 'gaia', 42),
('2024-12-18', 'Pas mal mais peut mieux faire', 6, 'vortex', 43),
('2025-04-30', 'Très intense', 9, 'serena', 44),
('2025-07-06', 'Personnages trop caricaturaux', 5, 'atlas', 45),
('2025-02-09', 'Magnifique scénario', 9, 'julian', 46),
('2025-08-23', 'Très bien réalisé', 8, 'crystal', 47),
('2025-05-10', 'Un peu prévisible', 6, 'tempo', 48),
('2025-03-18', 'Histoire captivante', 9, 'luna', 49),
('2025-06-02', 'Animation très réussie', 8, 'neo', 50);


INSERT INTO participe (id_artiste, id_media, id_perso)
VALUES
(2, 2, 2),
(3, 3, 3),
(1, 1, 1);
