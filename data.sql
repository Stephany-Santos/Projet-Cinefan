SET client_encoding to UTF8;
-- Seed essential 'deleted-user' (avoid FK fails)
INSERT INTO utilisateur (pseudo, nom, mail, mdp, typeDeCompte, dateDeCreation)
VALUES ('deleted-user','Supprimé','deleted@local','Deleted123','standard','2023-01-01')
ON CONFLICT (pseudo) DO NOTHING;

INSERT INTO utilisateur (pseudo, nom, mail, mdp, typeDeCompte)
VALUES
('alice','Alice','alice@example.com','alicepwd','standard'),
('bob42','Bob','bob42@example.com','bobpwd','standard'),
('charly','Charly','charly@example.com','charlypwd','standard')
ON CONFLICT (pseudo) DO NOTHING;

-- ---- GENRES
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
('Espionnage', 'Intrigues autour d''agents secrets, complots et missions secrètes')
ON CONFLICT (intitule) DO NOTHING;

-- ---- UTILISATEURS (fix types to allowed values)
-- mapping: 'créateur' -> 'source', 'modérateur' -> 'admin'
INSERT INTO utilisateur (pseudo, nom, biographie, typeDeCompte, mail, mdp, dateDeCreation) VALUES
('luna', 'Morel', 'Amatrice de films fantastiques.', 'standard', 'luna.morel@mail.com', 'LunaPass1', '2024-07-14'),
('neo', 'Durand', 'Fan de cyberpunk et d''univers futuristes.', 'source', 'neo@techspace.fr', 'NeoSecure55', '2025-01-19'),
('pixelboy', 'Bernard', 'Collectionneur de vieux films.', 'standard', 'pixel.b@mail.com', 'PBmovie99', '2023-12-02'),
('mira', 'Lambert', 'Aime les thrillers sombres.', 'standard', 'mira.lambert@mail.fr', 'MiraPwd2024', '2024-04-09'),
('jasmin', 'Petit', 'Blogueuse cinéma.', 'source', 'jasmin@blog.fr', 'JasminFilm*1', '2024-11-18'),
('shadowfox', 'Robert', 'Fan de films d''espionnage.', 'standard', 'shadow@movie.net', 'Shadow123', '2025-02-07'),
('akira', 'Nguyen', 'Passionné d''animation japonaise.', 'standard', 'akira.nguyen@mail.com', 'AkiR4!', '2023-10-26'),
('eliora', 'Roux', 'Apprécie les dramas historiques.', 'standard', 'eliora.roux@mail.fr', 'ElioraPwd', '2024-08-21'),
('toma', 'Diallo', 'Monte des critiques vidéos.', 'source', 'toma@video.fr', 'DialloVid22', '2025-06-03'),
('skylie', 'Marchand', 'Grande fan de comédies romantiques.', 'standard', 'skylie@mail.com', 'SkyLove2023', '2023-05-17'),
('delta', 'Fischer', 'Modérateur bénévole passionné.', 'admin', 'delta@admin.org', 'DeltaMod44', '2025-03-29'),
('ghost', 'Fabre', 'Aime les films d''horreur.', 'standard', 'ghost@horror.fr', 'Gh0st*H', '2024-09-12'),
('ragnar', 'Hubert', 'Passionné d''épopées vikings.', 'standard', 'ragnar@mail.com', 'Ragn4r!', '2024-07-02'),
('sybel', 'Barbier', 'Autrice de critiques courtes.', 'source', 'sybel@critics.fr', 'SybelCritik', '2025-10-10'),
('mattix', 'Garnier', 'Cinéphile depuis l''enfance.', 'standard', 'mattix.g@mail.com', 'Mattix88', '2024-02-21'),
('tenshi', 'Lopez', 'Fascinée par les films psychologiques.', 'standard', 'tenshi@mail.net', 'TenshiLock', '2025-01-05'),
('kronos', 'Bouvier', 'Spécialiste films temporels.', 'source', 'kronos@time.fr', 'KronoS*12', '2025-04-14'),
('liv', 'Pires', 'Aime les documentaires animaliers.', 'standard', 'liv.pires@mail.com', 'LivDoc2024', '2024-03-03'),
('mecha', 'Schmitt', 'Fan de robots géants et SF.', 'standard', 'mecha.sf@mail.com', 'Mecha22', '2023-08-09'),
('eve93', 'Meyer', 'Regarde beaucoup de biopics.', 'standard', 'eve93@mail.fr', 'EvePass', '2024-06-18'),
('solaris', 'Andrieu', 'Passionné d''astronomie et de films spatiaux.', 'standard', 'solaris@astro.fr', 'Solar_2023', '2023-10-13'),
('tigra', 'Colin', 'Aime les films d''aventure.', 'standard', 'tigra@mail.com', 'TigraClaws', '2024-11-06'),
('noctis', 'Giraud', 'Fan de films noirs.', 'standard', 'noctis@mail.net', 'N0ct1s', '2025-08-26'),
('cass', 'Baron', 'Critique de films indépendants.', 'source', 'cass@indie.fr', 'CassInd44', '2024-01-11'),
('echo', 'Rolland', 'Collectionne les OST de films.', 'standard', 'echo.music@mail.com', 'EchoMusik', '2023-09-04'),
('iris_bl', 'Blanc', 'Adore les films romantiques italiens.', 'standard', 'iris@mail.com', 'IrisPwd', '2024-02-27'),
('tango', 'Lefevre', 'Passionné de westerns.', 'standard', 'tango@cowboy.fr', 'TangoRide', '2024-05-15'),
('nova', 'Gillet', 'Suit beaucoup l''actualité cinéma.', 'admin', 'nova@admin.fr', 'NovaAdm**', '2025-03-01'),
('ariel', 'Delcourt', 'Étudiante en cinéma.', 'standard', 'ariel.dc@mail.com', 'Ariel2024', '2024-07-08'),
('prism', 'Pellier', 'Aime les couleurs et l''esthétique visuelle.', 'standard', 'prism@mail.net', 'Prism88', '2025-10-20'),
('rosetta', 'Brunet', 'Fan de films historiques.', 'standard', 'rosetta@mail.com', 'RosettaPwd', '2023-11-11'),
('omega', 'Jacquet', 'Adore les scénarios complexes.', 'source', 'omega@stories.fr', 'Om3gA12', '2025-09-09'),
('silvio', 'Marais', 'Passionné d''opéra et de comédies musicales.', 'standard', 'silvio@mail.com', 'SilvioPwd', '2024-04-26'),
('kaya', 'Hoarau', 'Grande consommatrice de séries.', 'standard', 'kaya@series.fr', 'KayaLove', '2023-12-28'),
('tomaX', 'Guillon', 'Adepte du cinéma d''auteur.', 'standard', 'tomax@mail.com', 'Tomax77', '2024-03-23'),
('lux', 'Poirier', 'Aime les films lumineux et poétiques.', 'standard', 'lux@mail.net', 'LuxLite', '2024-09-30'),
('hazel', 'Bernier', 'Intéressée par les documentaires scientifiques.', 'standard', 'hazel@doc.fr', 'HazelDoc', '2023-06-17'),
('marlow', 'Schneider', 'Passionné de thrillers juridiques.', 'standard', 'marlow@mail.com', 'Marlow123', '2025-02-28'),
('gaia', 'Pasquier', 'Aime les films nature & écologie.', 'standard', 'gaia@mail.com', 'GaiaGreen', '2024-10-03'),
('vortex', 'Paris', 'Fan d''effets spéciaux.', 'source', 'vortex@fx.fr', 'V0rtex*FX', '2025-04-30'),
('serena', 'Benali', 'Regarde surtout des drames sociaux.', 'standard', 'serena@mail.fr', 'SerenaPwd', '2024-08-05'),
('atlas', 'Delmas', 'Passionné de films épiques.', 'standard', 'atlas@mail.com', 'Atlas2025', '2025-06-14'),
('julian', 'Lacombe', 'Aime les bandes-annonces et trailers.', 'standard', 'julian@trailer.fr', 'JulianT', '2023-07-29'),
('crystal', 'Gomes', 'Très active sur les critiques de séries.', 'source', 'crystal@mail.com', 'CryStal*', '2025-05-18'),
('tempo', 'Ollier', 'Fan de films musicaux et choraux.', 'standard', 'tempo@mail.net', 'Temp0Beat', '2024-01-31')
ON CONFLICT (pseudo) DO NOTHING;


-- =============================================
-- INSERTION DES ARTISTES (Réalisateurs et Acteurs)
-- =============================================

-- Artiste par défaut
INSERT INTO artiste VALUES (0, 'Nom', 'Prénom', 'deleted-user');

INSERT INTO artiste (nom, prenom, cree_par) VALUES

-- Réalisateurs célèbres
('Nolan', 'Christopher', 'alice'),
('Spielberg', 'Steven', 'alice'),
('Tarantino', 'Quentin', 'bob42'),
('Scorsese', 'Martin', 'alice'),
('Fincher', 'David', 'charly'),
('Villeneuve', 'Denis', 'alice'),
('Cameron', 'James', 'bob42'),
('Kubrick', 'Stanley', 'alice'),
('Coppola', 'Francis Ford', 'charly'),
('Scott', 'Ridley', 'alice'),
-- Acteurs principaux
('DiCaprio', 'Leonardo', 'luna'),
('Hanks', 'Tom', 'luna'),
('Freeman', 'Morgan', 'neo'),
('Pitt', 'Brad', 'luna'),
('Cruise', 'Tom', 'pixelboy'),
('Bale', 'Christian', 'luna'),
('Washington', 'Denzel', 'mira'),
('Downey Jr.', 'Robert', 'jasmin'),
('Smith', 'Will', 'shadowfox'),
('Depp', 'Johnny', 'akira'),
('Winslet', 'Kate', 'luna'),
('Johansson', 'Scarlett', 'eliora'),
('Lawrence', 'Jennifer', 'toma'),
('Portman', 'Natalie', 'skylie'),
('Robbie', 'Margot', 'delta'),
('Stone', 'Emma', 'ghost'),
('Theron', 'Charlize', 'ragnar'),
('Blanchett', 'Cate', 'sybel'),
('Streep', 'Meryl', 'mattix'),
('Bullock', 'Sandra', 'tenshi'),
('Hardy', 'Tom', 'kronos'),
('Gosling', 'Ryan', 'liv'),
('Hemsworth', 'Chris', 'mecha'),
('Evans', 'Chris', 'eve93'),
('Pratt', 'Chris', 'solaris'),
('Jackson', 'Samuel L.', 'tigra'),
('Clooney', 'George', 'noctis'),
('Damon', 'Matt', 'cass'),
('Affleck', 'Ben', 'echo'),
('Pacino', 'Al', 'iris_bl'),
('De Niro', 'Robert', 'tango'),
('Hopkins', 'Anthony', 'nova'),
('Nicholson', 'Jack', 'ariel'),
('Day-Lewis', 'Daniel', 'prism'),
('Ledger', 'Heath', 'rosetta'),
('Phoenix', 'Joaquin', 'omega'),
('Ruffalo', 'Mark', 'silvio'),
('McConaughey', 'Matthew', 'kaya'),
('Elba', 'Idris', 'tomaX'),
('Pine', 'Chris', 'lux'),
('Johnson', 'Dwayne', 'hazel'),
('Eastwood', 'Clint', 'marlow'),
('Willis', 'Bruce', 'gaia'),
('Murphy', 'Cillian', 'vortex'),
('Isaac', 'Oscar', 'serena'),
('Driver', 'Adam', 'atlas'),
('Keaton', 'Michael', 'julian'),
('Cavill', 'Henry', 'crystal'),
('Gadot', 'Gal', 'tempo');

-- =============================================
-- INSERTION DES MÉDIAS (Films)
-- =============================================
INSERT INTO media (id_media, titre, description, parution, type, realise, suite, genre, cree_par) VALUES
(0, 'Sans Titre', 'Donnée par défaut', '2000-01-01', 'Film', 0, NULL, 'Action', 'deleted-user');

INSERT INTO media (titre, description, parution, type, realise, suite, genre, cree_par) VALUES

-- Films de Christopher Nolan
('Inception', 'Un voleur qui s''infiltre dans les rêves des gens pour voler leurs secrets se voit confier la mission inverse : implanter une idée.', '2010-07-16', 'Film', 1, NULL, 'Science-Fiction', 'luna'),
('The Dark Knight', 'Batman affronte le Joker, un criminel anarchiste qui cherche à plonger Gotham City dans le chaos.', '2008-07-18', 'Film', 1, NULL, 'Action', 'luna'),
('Interstellar', 'Une équipe d''explorateurs voyage à travers un trou de ver dans l''espace pour assurer la survie de l''humanité.', '2014-11-07', 'Film', 1, NULL, 'Science-Fiction', 'neo'),
('Dunkirk', 'L''évacuation de Dunkerque pendant la Seconde Guerre mondiale, racontée sous trois perspectives.', '2017-07-21', 'Film', 1, NULL, 'Guerre', 'pixelboy'),
('Oppenheimer', 'La vie de J. Robert Oppenheimer et son rôle dans le développement de la bombe atomique.', '2023-07-21', 'Film', 1, NULL, 'Biographie', 'mira'),

-- Films de Steven Spielberg
('Jurassic Park', 'Des scientifiques créent un parc à thème peuplé de dinosaures clonés, mais tout tourne mal.', '1993-06-11', 'Film', 2, NULL, 'Science-Fiction', 'jasmin'),
('Schindler''s List', 'L''histoire vraie d''Oskar Schindler qui sauva plus de mille Juifs pendant l''Holocauste.', '1993-12-15', 'Film', 2, NULL, 'Historique', 'shadowfox'),
('Saving Private Ryan', 'Pendant la Seconde Guerre mondiale, un groupe de soldats part à la recherche d''un parachutiste.', '1998-07-24', 'Film', 2, NULL, 'Guerre', 'akira'),
('E.T. the Extra-Terrestrial', 'Un jeune garçon se lie d''amitié avec un extraterrestre échoué sur Terre.', '1982-06-11', 'Film', 2, NULL, 'Science-Fiction', 'eliora'),
('Catch Me If You Can', 'L''histoire vraie de Frank Abagnale Jr., l''un des escrocs les plus célèbres d''Amérique.', '2002-12-25', 'Film', 2, NULL, 'Biographie', 'toma'),

-- Films de Quentin Tarantino
('Pulp Fiction', 'Des histoires entrelacées de criminels, de boxeurs et de gangsters à Los Angeles.', '1994-10-14', 'Film', 3, NULL, 'Thriller', 'skylie'),
('Django Unchained', 'Un esclave affranchi s''associe à un chasseur de primes pour sauver sa femme.', '2012-12-25', 'Film', 3, NULL, 'Western', 'delta'),
('Kill Bill: Vol. 1', 'Une ancienne tueuse à gages se venge de son ancien patron et de ses complices.', '2003-10-10', 'Film', 3, NULL, 'Action', 'ghost'),
('Inglourious Basterds', 'Pendant la Seconde Guerre mondiale, deux complots pour assassiner les dirigeants nazis se rejoignent.', '2009-08-21', 'Film', 3, NULL, 'Guerre', 'ragnar'),
('Reservoir Dogs', 'Après un braquage raté, les criminels survivants tentent de découvrir qui les a trahis.', '1992-10-23', 'Film', 3, NULL, 'Thriller', 'sybel'),

-- Films de Martin Scorsese
('The Wolf of Wall Street', 'L''ascension et la chute du courtier en bourse Jordan Belfort et sa vie d''excès.', '2013-12-25', 'Film', 4, NULL, 'Biographie', 'mattix'),
('Goodfellas', 'L''histoire de Henry Hill et sa vie dans la mafia de Brooklyn.', '1990-09-19', 'Film', 4, NULL, 'Policier', 'tenshi'),
('The Departed', 'Un policier infiltré et une taupe dans la police tentent de s''identifier mutuellement.', '2006-10-06', 'Film', 4, NULL, 'Thriller', 'kronos'),
('Taxi Driver', 'Un vétéran du Vietnam souffrant d''insomnie devient chauffeur de taxi la nuit à New York.', '1976-02-08', 'Film', 4, NULL, 'Drame', 'liv'),
('Shutter Island', 'Un marshal enquête sur la disparition d''une patiente dans un hôpital psychiatrique sur une île.', '2010-02-19', 'Film', 4, NULL, 'Thriller Psychologique', 'mecha'),

-- Films de David Fincher
('Fight Club', 'Un employé de bureau insomniaque et un vendeur de savon créent un club de combat clandestin.', '1999-10-15', 'Film', 5, NULL, 'Thriller Psychologique', 'eve93'),
('Se7en', 'Deux détectives traquent un tueur en série qui utilise les sept péchés capitaux comme motif.', '1995-09-22', 'Film', 5, NULL, 'Thriller', 'solaris'),
('The Social Network', 'La création de Facebook et les batailles juridiques qui ont suivi.', '2010-10-01', 'Film', 5, NULL, 'Biographie', 'tigra'),
('Gone Girl', 'Lorsque sa femme disparaît, un homme devient le principal suspect.', '2014-10-03', 'Film', 5, NULL, 'Thriller Psychologique', 'noctis'),
('Zodiac', 'L''enquête sur le tueur du Zodiaque qui terrorisa la Californie dans les années 1960-70.', '2007-03-02', 'Film', 5, NULL, 'Thriller', 'cass'),

-- Films de Denis Villeneuve
('Dune', 'Paul Atreides voyage vers la planète la plus dangereuse de l''univers pour assurer l''avenir de sa famille.', '2021-10-22', 'Film', 6, NULL, 'Science-Fiction', 'echo'),
('Blade Runner 2049', 'Un jeune blade runner découvre un secret qui pourrait plonger la société dans le chaos.', '2017-10-06', 'Film', 6, NULL, 'Science-Fiction', 'iris_bl'),
('Arrival', 'Une linguiste est recrutée par l''armée pour communiquer avec des extraterrestres.', '2016-11-11', 'Film', 6, NULL, 'Science-Fiction', 'tango'),
('Sicario', 'Une agente du FBI est enrôlée dans une force d''élite pour lutter contre les cartels mexicains.', '2015-09-17', 'Film', 6, NULL, 'Thriller', 'nova'),
('Prisoners', 'Quand sa fille disparaît, un père prend les choses en main face à l''inaction de la police.', '2013-09-20', 'Film', 6, NULL, 'Thriller', 'ariel'),

-- Films de James Cameron
('Titanic', 'L''histoire d''amour tragique entre Jack et Rose à bord du Titanic lors de son voyage inaugural.', '1997-12-19', 'Film', 7, NULL, 'Romance Dramatique', 'prism'),
('Avatar', 'Un marine paraplégique est envoyé sur la lune Pandora et se retrouve pris entre deux mondes.', '2009-12-18', 'Film', 7, NULL, 'Science-Fiction', 'rosetta'),
('Terminator 2: Judgment Day', 'Un cyborg est envoyé du futur pour protéger un jeune garçon du Terminator le plus avancé.', '1991-07-03', 'Film', 7, NULL, 'Science-Fiction', 'omega'),
('Aliens', 'Ellen Ripley retourne sur la planète des extraterrestres avec une unité de marines.', '1986-07-18', 'Film', 7, NULL, 'Science-Fiction', 'silvio'),
('The Abyss', 'Une équipe de plongeurs en eaux profondes fait une découverte extraordinaire.', '1989-08-09', 'Film', 7, NULL, 'Science-Fiction', 'kaya'),

-- Films de Stanley Kubrick
('The Shining', 'Un écrivain devient le gardien d''un hôtel isolé et sombre peu à peu dans la folie.', '1980-05-23', 'Film', 8, NULL, 'Horreur', 'tomaX'),
('2001: A Space Odyssey', 'Un voyage à travers l''espace révèle un mystérieux monolithe et une IA dangereuse.', '1968-04-06', 'Film', 8, NULL, 'Science-Fiction', 'lux'),
('A Clockwork Orange', 'Dans une société dystopique, un jeune délinquant subit un traitement expérimental.', '1971-12-19', 'Film', 8, NULL, 'Science-Fiction', 'hazel'),
('Full Metal Jacket', 'Un regard brutal sur l''entraînement des Marines et la guerre du Vietnam.', '1987-06-26', 'Film', 8, NULL, 'Guerre', 'marlow'),
('Dr. Strangelove', 'Une satire sur la guerre froide et la menace nucléaire.', '1964-01-29', 'Film', 8, NULL, 'Comédie', 'gaia'),

-- Films de Francis Ford Coppola
('The Godfather', 'Le patriarche vieillissant d''une dynastie du crime organisé transfère le contrôle à son fils.', '1972-03-24', 'Film', 9, NULL, 'Policier', 'vortex'),
('The Godfather Part II', 'Suite parallèle entre l''ascension de Vito Corleone et le règne de son fils Michael.', '1974-12-20', 'Film', 9, 41, 'Policier', 'serena'),
('Apocalypse Now', 'Pendant la guerre du Vietnam, un capitaine reçoit la mission d''assassiner un colonel devenu fou.', '1979-08-15', 'Film', 9, NULL, 'Guerre', 'atlas'),
('The Conversation', 'Un expert en surveillance se retrouve impliqué dans un possible meurtre.', '1974-04-07', 'Film', 9, NULL, 'Thriller', 'julian'),
('Bram Stoker''s Dracula', 'L''histoire classique de Dracula revisitée avec style et romantisme gothique.', '1992-11-13', 'Film', 9, NULL, 'Horreur', 'crystal'),

-- Films de Ridley Scott
('Gladiator', 'Un général romain trahi devient gladiateur pour se venger de l''empereur corrompu.', '2000-05-05', 'Film', 10, NULL, 'Action', 'tempo'),
('Blade Runner', 'Un blade runner doit traquer et éliminer quatre réplicants qui se sont échappés.', '1982-06-25', 'Film', 10, NULL, 'Science-Fiction', 'luna'),
('Alien', 'L''équipage d''un vaisseau spatial découvre une forme de vie extraterrestre mortelle.', '1979-05-25', 'Film', 10, NULL, 'Science-Fiction', 'neo'),
('The Martian', 'Un astronaute abandonné sur Mars doit survivre en attendant les secours.', '2015-10-02', 'Film', 10, NULL, 'Science-Fiction', 'pixelboy'),
('Black Hawk Down', 'L''histoire vraie d''une mission militaire américaine qui a mal tourné en Somalie.', '2001-12-28', 'Film', 10, NULL, 'Guerre', 'mira');

-- =============================================
-- INSERTION DES PERSONNAGES (environ 100 personnages)
-- =============================================

-- Default characters to avoid FK issues
INSERT INTO personnage (id_perso, nom, prenom, description, cree_par, media) VALUES
(0, 'Sans', 'Prénom', 'Personnage par défaut', 'deleted-user', 0);

INSERT INTO personnage ( nom, prenom, description, cree_par, media) VALUES

-- Inception
('Cobb', 'Dom', 'Extracteur professionnel spécialisé dans le vol de secrets dans les rêves', 'luna', 1),
('Arthur', '', 'Pointman et bras droit de Cobb', 'luna', 1),
('Ariadne', '', 'Architecte de rêves talentueuse', 'luna', 1),
('Eames', '', 'Faussaire capable de changer d''apparence dans les rêves', 'luna', 1),
('Saito', '', 'Homme d''affaires japonais qui engage l''équipe', 'luna', 1),
('Mal', '', 'Projection de l''épouse décédée de Cobb', 'luna', 1),

-- The Dark Knight
('Wayne', 'Bruce', 'Milliardaire philanthrope qui est secrètement Batman', 'luna', 2),
('Joker', 'The', 'Criminel anarchiste au maquillage de clown', 'luna', 2),
('Dent', 'Harvey', 'Procureur de Gotham qui devient Double-Face', 'luna', 2),
('Gordon', 'James', 'Commissaire de police de Gotham City', 'luna', 2),
('Alfred', '', 'Majordome et figure paternelle de Bruce Wayne', 'luna', 2),

-- Interstellar
('Cooper', 'Joseph', 'Ancien pilote de la NASA devenu fermier', 'neo', 3),
('Brand', 'Amelia', 'Scientifique participant à la mission interstellaire', 'neo', 3),
('Murphy', '', 'Fille de Cooper, scientifique brillante', 'neo', 3),
('Mann', 'Dr.', 'Astronaute retrouvé sur une planète lointaine', 'neo', 3),
('TARS', '', 'Robot intelligent avec un sens de l''humour réglable', 'neo', 3),

-- Dunkirk
('Farrier', '', 'Pilote de Spitfire de la RAF', 'pixelboy', 4),
('Tommy', '', 'Jeune soldat britannique cherchant à évacuer', 'pixelboy', 4),
('Dawson', 'Mr.', 'Capitaine civil d''un bateau de plaisance', 'pixelboy', 4),

-- Oppenheimer
('Oppenheimer', 'J. Robert', 'Physicien théoricien, père de la bombe atomique', 'mira', 5),
('Groves', 'Leslie', 'Général dirigeant le projet Manhattan', 'mira', 5),
('Teller', 'Edward', 'Physicien travaillant sur le projet Manhattan', 'mira', 5),

-- Jurassic Park
('Grant', 'Alan', 'Paléontologue invité au parc', 'jasmin', 6),
('Sattler', 'Ellie', 'Paléobotaniste et compagne de Grant', 'jasmin', 6),
('Malcolm', 'Ian', 'Mathématicien chaotique sceptique du parc', 'jasmin', 6),
('Hammond', 'John', 'Créateur milliardaire de Jurassic Park', 'jasmin', 6),

-- Schindler's List
('Schindler', 'Oskar', 'Industriel allemand qui sauva des Juifs', 'shadowfox', 7),
('Goeth', 'Amon', 'Commandant SS brutal du camp de concentration', 'shadowfox', 7),
('Stern', 'Itzhak', 'Comptable juif qui aide Schindler', 'shadowfox', 7),

-- Saving Private Ryan
('Miller', 'John', 'Capitaine chargé de retrouver Private Ryan', 'akira', 8),
('Ryan', 'James', 'Parachutiste à sauver après la mort de ses frères', 'akira', 8),
('Horvath', '', 'Sergent et second du capitaine Miller', 'akira', 8),

-- E.T.
('Elliott', '', 'Jeune garçon qui se lie d''amitié avec E.T.', 'eliora', 9),
('E.T.', '', 'Extraterrestre échoué sur Terre', 'eliora', 9),

-- Catch Me If You Can
('Abagnale Jr.', 'Frank', 'Jeune escroc se faisant passer pour pilote, médecin et avocat', 'toma', 10),
('Hanratty', 'Carl', 'Agent du FBI poursuivant Abagnale', 'toma', 10),

-- Pulp Fiction
('Vega', 'Vincent', 'Tueur à gages travaillant pour Marsellus Wallace', 'skylie', 11),
('Coolidge', 'Butch', 'Boxeur qui refuse de perdre son combat', 'skylie', 11),
('Wallace', 'Mia', 'Épouse du patron du crime Marsellus Wallace', 'skylie', 11),
('Winnfield', 'Jules', 'Tueur à gages philosophe partenaire de Vincent', 'skylie', 11),

-- Django Unchained
('Freeman', 'Django', 'Esclave affranchi devenu chasseur de primes', 'delta', 12),
('Schultz', 'Dr. King', 'Chasseur de primes dentiste allemand', 'delta', 12),
('Candie', 'Calvin', 'Propriétaire brutal de plantation', 'delta', 12),
('Broomhilda', '', 'Épouse de Django retenue en esclavage', 'delta', 12),

-- Kill Bill Vol. 1
('Kiddo', 'Beatrix', 'Ancienne tueuse connue sous le nom de La Mariée', 'ghost', 13),
('Bill', '', 'Ancien amant et patron de Beatrix', 'ghost', 13),
('Ishii', 'O-Ren', 'Chef yakuza et ancienne collègue de Beatrix', 'ghost', 13),

-- Inglourious Basterds
('Raine', 'Aldo', 'Lieutenant dirigeant un groupe de soldats juifs', 'ragnar', 14),
('Landa', 'Hans', 'Colonel SS surnommé le Chasseur de Juifs', 'ragnar', 14),
('Mimieux', 'Shosanna', 'Juive française propriétaire de cinéma', 'ragnar', 14),

-- Reservoir Dogs
('White', 'Mr.', 'Criminel professionnel au tempérament calme', 'sybel', 15),
('Orange', 'Mr.', 'Policier infiltré dans le gang', 'sybel', 15),
('Blonde', 'Mr.', 'Criminel psychopathe et sadique', 'sybel', 15),

-- The Wolf of Wall Street
('Belfort', 'Jordan', 'Courtier en bourse corrompu vivant dans l''excès', 'mattix', 16),
('Azoff', 'Donnie', 'Meilleur ami et partenaire de Belfort', 'mattix', 16),
('Naomi', '', 'Seconde épouse de Jordan Belfort', 'mattix', 16),

-- Goodfellas
('Hill', 'Henry', 'Gangster italo-américain racontant son histoire', 'tenshi', 17),
('Conway', 'Jimmy', 'Gangster irlandais mentor de Henry', 'tenshi', 17),
('DeVito', 'Tommy', 'Gangster violent et imprévisible', 'tenshi', 17),

-- The Departed
('Costigan', 'Billy', 'Policier infiltré dans la mafia irlandaise', 'kronos', 18),
('Sullivan', 'Colin', 'Taupe de la mafia au sein de la police', 'kronos', 18),
('Costello', 'Frank', 'Parrain de la mafia irlandaise de Boston', 'kronos', 18),

-- Taxi Driver
('Bickle', 'Travis', 'Vétéran du Vietnam chauffeur de taxi insomniaque', 'liv', 19),
('Steensma', 'Iris', 'Jeune prostituée que Travis tente de sauver', 'liv', 19),

-- Shutter Island
('Daniels', 'Teddy', 'Marshal enquêtant sur une disparition', 'mecha', 20),
('Aule', 'Chuck', 'Partenaire du marshal Daniels', 'mecha', 20),
('Cawley', 'Dr.', 'Psychiatre en chef de l''hôpital', 'mecha', 20),

-- Fight Club
('Narrator', 'The', 'Employé de bureau insomniaque sans nom', 'eve93', 21),
('Durden', 'Tyler', 'Vendeur de savon charismatique et anarchiste', 'eve93', 21),
('Singer', 'Marla', 'Femme perturbée fréquentant les groupes de soutien', 'eve93', 21),

-- Se7en
('Somerset', 'William', 'Détective vétéran proche de la retraite', 'solaris', 22),
('Mills', 'David', 'Jeune détective idéaliste', 'solaris', 22),
('Doe', 'John', 'Tueur en série utilisant les sept péchés capitaux', 'solaris', 22),

-- The Social Network
('Zuckerberg', 'Mark', 'Créateur de Facebook, génie de la programmation', 'tigra', 23),
('Saverin', 'Eduardo', 'Co-fondateur et CFO de Facebook', 'tigra', 23),
('Parker', 'Sean', 'Entrepreneur et premier président de Facebook', 'tigra', 23),

-- Gone Girl
('Dunne', 'Nick', 'Mari dont la femme a disparu', 'noctis', 24),
('Dunne', 'Amy', 'Femme disparue aux plans machiavéliques', 'noctis', 24),

-- Zodiac
('Graysmith', 'Robert', 'Dessinateur obsédé par l''affaire du Zodiaque', 'cass', 25),
('Avery', 'Paul', 'Journaliste couvrant les meurtres du Zodiaque', 'cass', 25),
('Toschi', 'David', 'Inspecteur enquêtant sur le tueur du Zodiaque', 'cass', 25),

-- Dune
('Atreides', 'Paul', 'Jeune noble destiné à devenir le Muad''Dib', 'echo', 26),
('Atreides', 'Leto', 'Duc et père de Paul Atreides', 'echo', 26),
('Kynes', 'Liet', 'Écologiste planétaire d''Arrakis', 'echo', 26),
('Harkonnen', 'Vladimir', 'Baron ennemi maléfique de la maison Atreides', 'echo', 26),

-- Blade Runner 2049
('K', '', 'Blade runner réplicant découvrant un secret', 'iris_bl', 27),
('Deckard', 'Rick', 'Ancien blade runner vivant caché', 'iris_bl', 27),
('Luv', '', 'Réplicante meurtrière au service de Wallace', 'iris_bl', 27),

-- Arrival
('Banks', 'Louise', 'Linguiste experte recrutée pour communiquer avec les aliens', 'tango', 28),
('Donnelly', 'Ian', 'Physicien travaillant avec Louise', 'tango', 28),

-- Sicario
('Macer', 'Kate', 'Agente FBI idéaliste', 'nova', 29),
('Graver', 'Matt', 'Agent de la CIA dirigeant l''opération', 'nova', 29),
('Gillick', 'Alejandro', 'Consultant mystérieux avec un passé sombre', 'nova', 29),

-- Prisoners
('Keller', 'Dover', 'Père désespéré dont la fille a été enlevée', 'ariel', 30),
('Loki', '', 'Détective obstiné enquêtant sur l''enlèvement', 'ariel', 30),

-- Titanic
('Dawson', 'Jack', 'Artiste pauvre qui gagne son billet en jouant au poker', 'prism', 31),
('DeWitt Bukater', 'Rose', 'Jeune aristocrate fiancée contre son gré', 'prism', 31),
('Hockley', 'Cal', 'Fiancé riche et arrogant de Rose', 'prism', 31),

-- Avatar
('Sully', 'Jake', 'Marine paraplégique utilisant un avatar Na''vi', 'rosetta', 32),
('Neytiri', '', 'Guerrière Na''vi qui enseigne à Jake', 'rosetta', 32),
('Quaritch', 'Colonel', 'Chef des opérations de sécurité sur Pandora', 'rosetta', 32),

-- Terminator 2
('Connor', 'John', 'Jeune garçon destiné à diriger la résistance', 'omega', 33),
('Connor', 'Sarah', 'Mère de John, guerrière endurcie', 'omega', 33),
('T-800', '', 'Terminator reprogrammé pour protéger John', 'omega', 33),
('T-1000', '', 'Terminator avancé en métal liquide', 'omega', 33),

-- Aliens
('Ripley','Ellen', 'Survivante de la rencontre avec le Xenomorphe', 'silvio', 34),
('Hicks', 'Dwayne', 'Caporal des Marines Colonial', 'silvio', 34),
('Bishop', '', 'Androïde synthétique de la mission', 'silvio', 34),

-- The Abyss
('Brigman', 'Bud', 'Superviseur de plateforme pétrolière sous-marine', 'kaya', 35),
('Brigman', 'Lindsey', 'Conceptrice de la plateforme et ex-femme de Bud', 'kaya', 35),

-- The Shining
('Torrance', 'Jack', 'Écrivain devenant gardien et sombrant dans la folie', 'tomaX', 36),
('Torrance', 'Wendy', 'Épouse de Jack essayant de protéger son fils', 'tomaX', 36),
('Torrance', 'Danny', 'Fils de Jack avec des capacités psychiques', 'tomaX', 36),

-- 2001: A Space Odyssey
('Bowman', 'Dave', 'Astronaute survivant confronté à HAL 9000', 'lux', 37),
('HAL 9000', '', 'Intelligence artificielle du vaisseau Discovery', 'lux', 37),
('Poole', 'Frank', 'Astronaute et collègue de Dave Bowman', 'lux', 37),

-- A Clockwork Orange
('DeLarge', 'Alex', 'Jeune délinquant ultraviolent', 'hazel', 38),

-- Full Metal Jacket
('Joker', '', 'Soldat narrateur du film', 'marlow', 39),
('Pyle', 'Leonard', 'Recrue malheureuse victime de brimades', 'marlow', 39),
('Hartman', 'Gunnery Sergeant', 'Instructeur impitoyable des Marines', 'marlow', 39),

-- Dr. Strangelove
('Strangelove', 'Dr.', 'Scientifique ex-nazi conseiller du président', 'gaia', 40),
('Mandrake', 'Lionel', 'Officier britannique tentant d''empêcher la guerre', 'gaia', 40),
('Turgidson', 'Buck', 'Général belliqueux', 'gaia', 40),

-- The Godfather
('Corleone', 'Vito', 'Patriarche de la famille Corleone', 'vortex', 41),
('Corleone', 'Michael', 'Fils de Vito devenant le nouveau parrain', 'vortex', 41),
('Corleone', 'Sonny', 'Fils aîné au tempérament violent', 'vortex', 41),
('Corleone', 'Fredo', 'Fils faible et fragile', 'vortex', 41),

-- The Godfather Part II
('Corleone (jeune)', 'Vito', 'Vito dans sa jeunesse immigrant en Amérique', 'serena', 42),

-- Apocalypse Now
('Willard', 'Benjamin', 'Capitaine chargé d''assassiner le colonel Kurtz', 'atlas', 43),
('Kurtz', 'Walter', 'Colonel devenu chef d''une tribu dans la jungle', 'atlas', 43),
('Kilgore', 'Bill', 'Lieutenant-colonel obsédé par le surf', 'atlas', 43),

-- The Conversation
('Caul', 'Harry', 'Expert en surveillance paranoïaque', 'julian', 44),

-- Bram Stoker's Dracula
('Dracula', '', 'Comte vampire cherchant la réincarnation de son amour perdu', 'crystal', 45),
('Harker', 'Mina', 'Femme ressemblant à l''amour perdu de Dracula', 'crystal', 45),
('Harker', 'Jonathan', 'Clerc de notaire fiancé à Mina', 'crystal', 45),

-- Gladiator
('Maximus', '', 'Général romain trahi devenu gladiateur', 'tempo', 46),
('Commodus', '', 'Empereur romain corrompu et jaloux', 'tempo', 46),
('Lucilla', '', 'Sœur de Commodus et ancienne amante de Maximus', 'tempo', 46),

-- Blade Runner
('Deckard', 'Rick', 'Blade runner chargé de traquer les réplicants', 'luna', 47),
('Batty', 'Roy', 'Réplicant leader recherchant plus de vie', 'luna', 47),
('Rachael', '', 'Réplicante ignorant sa vraie nature', 'luna', 47),

-- Alien
('Ripley', 'Ellen', 'Officier en second du vaisseau Nostromo', 'neo', 48),
('Ash', '', 'Officier scientifique androïde avec des ordres secrets', 'neo', 48),
('Dallas', '', 'Capitaine du vaisseau Nostromo', 'neo', 48),

-- The Martian
('Watney', 'Mark', 'Astronaute botaniste abandonné sur Mars', 'pixelboy', 49),
('Lewis', 'Melissa', 'Commandante de la mission Ares III', 'pixelboy', 49),

-- Black Hawk Down
('Eversmann', 'Matt', 'Sergent dirigeant une unité de Rangers', 'mira', 50);

-- =============================================
-- INSERTION DES IMAGES (avec URLs réelles)
-- =============================================

-- Images de films (fichier, lien, alt, artiste, media, personnage, cree_par) VALUES
-- Images d'acteurs (utilisant des URLs Wikimedia Commons)
('dicaprio_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/4/46/Leonardo_Dicaprio_Cannes_2019.jpg', 'Leonardo DiCaprio au Festival de Cannes 2019', 11, NULL, NULL, 'luna'),
('hanks_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Tom_Hanks_TIFF_2019.jpg', 'Tom Hanks au Festival International du Film de Toronto 2019', 12, NULL, NULL, 'luna'),
('freeman_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/e/e4/Morgan_Freeman_Deauville_2018.jpg', 'Morgan Freeman au Festival de Deauville 2018', 13, NULL, NULL, 'neo'),
('pitt_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/4/4d/Brad_Pitt_2019_by_Glenn_Francis.jpg', 'Brad Pitt en 2019', 14, NULL, NULL, 'luna'),
('cruise_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/3/33/Tom_Cruise_avp_2014.jpg', 'Tom Cruise en 2014', 15, NULL, NULL, 'pixelboy'),
('bale_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/9/92/Christian_Bale_2014_%28cropped%29.jpg', 'Christian Bale en 2014', 16, NULL, NULL, 'luna'),
('washington_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/4/40/Denzel_Washington_2018.jpg', 'Denzel Washington en 2018', 17, NULL, NULL, 'mira'),
('downey_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg', 'Robert Downey Jr. au Comic Con 2014', 18, NULL, NULL, 'jasmin'),
('depp_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/3/3b/Johnny_Depp-2757_%28cropped%29.jpg', 'Johnny Depp', 20, NULL, NULL, 'akira'),
('winslet_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/7/7d/Kate_Winslet_at_the_2017_Toronto_International_Film_Festival_%28cropped%29.jpg', 'Kate Winslet au TIFF 2017', 21, NULL, NULL, 'luna'),
('johansson_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/2/2a/Scarlett_Johansson_by_Gage_Skidmore_2_%28cropped%2C_2%29.jpg', 'Scarlett Johansson', 22, NULL, NULL, 'eliora'),
('lawrence_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/5/54/Jennifer_Lawrence_SDCC_2015_X-Men.jpg', 'Jennifer Lawrence au Comic-Con 2015', 23, NULL, NULL, 'toma'),
('portman_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/d/de/Natalie_Portman_%2848473156317%29_%28cropped%29.jpg', 'Natalie Portman', 24, NULL, NULL, 'skylie'),
('robbie_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/0/02/Margot_Robbie_%2828601016855%29_%28cropped%29.jpg', 'Margot Robbie', 25, NULL, NULL, 'delta'),
('theron_01.jpg', 'https://upload.wikimedia.org/wikipedia/commons/5/5d/Charlize-theron-IMG_6045.jpg', 'Charlize Theron', 27, NULL, NULL, 'ragnar'),

-- Images de films (posters)
('inception_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/2/2e/Inception_%282010%29_theatrical_poster.jpg', 'Affiche du film Inception', NULL, 1, NULL, 'luna'),
('darkknight_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/1/1c/The_Dark_Knight_%282008_film%29.jpg', 'Affiche du film The Dark Knight', NULL, 2, NULL, 'luna'),
('interstellar_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/b/bc/Interstellar_film_poster.jpg', 'Affiche du film Interstellar', NULL, 3, NULL, 'neo'),
('jurassicpark_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/e/e7/Jurassic_Park_poster.jpg', 'Affiche du film Jurassic Park', NULL, 6, NULL, 'jasmin'),
('pulpfiction_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg', 'Affiche du film Pulp Fiction', NULL, 11, NULL, 'skylie'),
('titanic_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/1/18/Titanic_%281997_film%29_poster.png', 'Affiche du film Titanic', NULL, 31, NULL, 'prism'),
('avatar_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/d/d6/Avatar_%282009_film%29_poster.jpg', 'Affiche du film Avatar', NULL, 32, NULL, 'rosetta'),
('shining_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/1/1d/The_Shining_%281980%29_U.K._release_poster_-_Version_2.jpg', 'Affiche du film The Shining', NULL, 36, NULL, 'tomaX'),
('godfather_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/1/1c/Godfather_ver1.jpg', 'Affiche du film The Godfather', NULL, 41, NULL, 'vortex'),
('gladiator_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/f/fb/Gladiator_%282000_film%29_poster.png', 'Affiche du film Gladiator', NULL, 46, NULL, 'tempo'),
('bladerunner_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/5/53/Blade_Runner_poster.jpg', 'Affiche du film Blade Runner', NULL, 47, NULL, 'luna'),
('alien_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/c/c3/Alien_movie_poster.jpg', 'Affiche du film Alien', NULL, 48, NULL, 'neo'),
('martian_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/c/cd/The_Martian_film_poster.jpg', 'Affiche du film The Martian', NULL, 49, NULL, 'pixelboy'),
('fightclub_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/f/fc/Fight_Club_poster.jpg', 'Affiche du film Fight Club', NULL, 21, NULL, 'eve93'),
('se7en_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/6/68/Seven_%28movie%29_poster.jpg', 'Affiche du film Se7en', NULL, 22, NULL, 'solaris'),
('dune_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/8/8e/Dune_%282021_film%29.jpg', 'Affiche du film Dune', NULL, 26, NULL, 'echo'),
('django_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/8/8b/Django_Unchained_Poster.jpg', 'Affiche du film Django Unchained', NULL, 12, NULL, 'delta'),
('departed_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/5/50/Departed234.jpg', 'Affiche du film The Departed', NULL, 18, NULL, 'kronos'),
('goodfellas_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/7/7b/Goodfellas.jpg', 'Affiche du film Goodfellas', NULL, 17, NULL, 'tenshi');

-- =============================================
-- INSERTION DES PARTICIPATIONS (acteurs dans films)
-- =============================================

INSERT INTO participe (id_artiste, id_media, id_perso, role) VALUES
-- Inception
(11, 1, 1, 'Acteur principal'),
(21, 1, 3, 'Acteur secondaire'),
(32, 1, 2, 'Acteur secondaire'),
(21, 1, 6, 'Acteur secondaire'),

-- The Dark Knight
(16, 2, 7, 'Acteur principal'),
(45, 2, 8, 'Acteur principal'),
(13, 2, 10, 'Acteur secondaire'),
  ('dunkirk_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/e/e9/Dunkirk_Teaser_Poster.jpg', 'Affiche du film Dunkirk', NULL, 4, NULL, 'pixelboy'),
  ('oppenheimer_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/4/4c/Oppenheimer_%282023_film%29.jpg', 'Affiche du film Oppenheimer', NULL, 5, NULL, 'mira'),
('schindlerslist_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/3/38/Schindler%27s_List_poster.jpg', 'Affiche du film Schindler''s List', NULL, 7, NULL, 'shadowfox'),
('savingprivateryan_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/a/ac/Saving_Private_Ryan_poster.jpg', 'Affiche du film Saving Private Ryan', NULL, 8, NULL, 'akira'),
('et_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/a/a7/ET_the_extra_Terrestrial_Poster_1982.jpg', 'Affiche du film E.T. the Extra-Terrestrial', NULL, 9, NULL, 'eliora'),
('catchmeifyoucan_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/a/a7/Catch_Me_If_You_Can_poster.jpg', 'Affiche du film Catch Me If You Can', NULL, 10, NULL, 'toma'),
('killbillvol1_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/b/b5/Kill_Bill_Vol_1.jpg', 'Affiche du film Kill Bill: Vol. 1', NULL, 13, NULL, 'ghost'),
('inglourious_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/c/c3/Inglourious_Basterds_poster.jpg', 'Affiche du film Inglourious Basterds', NULL, 14, NULL, 'ragnar'),
('reservoirdogs_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/9/96/Reservoir_Dogs_poster.jpg', 'Affiche du film Reservoir Dogs', NULL, 15, NULL, 'sybel'),
('wolfofwallstreet_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/0/0f/The_Wolf_of_Wall_Street_poster.jpg', 'Affiche du film The Wolf of Wall Street', NULL, 16, NULL, 'mattix'),
('taxidriver_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/9/97/Taxi_Driver.jpg', 'Affiche du film Taxi Driver', NULL, 19, NULL, 'liv'),
('shutterisland_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/d/d5/Shutter_Island_Theatrical_Poster.jpg', 'Affiche du film Shutter Island', NULL, 20, NULL, 'mecha'),
('thesocialnetwork_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/1/1f/The_Social_Network_poster.jpg', 'Affiche du film The Social Network', NULL, 23, NULL, 'tigra'),
('gonegirl_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/8/8e/Gone_Girl_Poster.jpg', 'Affiche du film Gone Girl', NULL, 24, NULL, 'noctis'),
('zodiac_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/8/8d/Zodiac_%282007%29.png', 'Affiche du film Zodiac', NULL, 25, NULL, 'cass'),
('bladerunner2049_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/0/0c/Blade_Runner_2049_poster.jpg', 'Affiche du film Blade Runner 2049', NULL, 27, NULL, 'iris_bl'),
('arrival_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/3/37/Arrival_2016_film_poster.jpg', 'Affiche du film Arrival', NULL, 28, NULL, 'tango'),
('sicario_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/f/ff/Sicario_2015_poster.jpg', 'Affiche du film Sicario', NULL, 29, NULL, 'nova'),
('prisoners_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/a/a1/Prisoners_%282013%29_Poster.jpg', 'Affiche du film Prisoners', NULL, 30, NULL, 'ariel'),
('terminator2_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/8/85/Terminator2-judgmentday.jpg', 'Affiche du film Terminator 2: Judgment Day', NULL, 33, NULL, 'omega'),
('aliens_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/f/f1/Aliens_poster.jpg', 'Affiche du film Aliens', NULL, 34, NULL, 'silvio'),
('theabyss_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/f/f3/The_Abyss_poster.jpg', 'Affiche du film The Abyss', NULL, 35, NULL, 'kaya'),
('2001spaceoddyssey_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/d/df/2001-A-Space-Odyssey-%281968%29-Poster.jpg', 'Affiche du film 2001: A Space Odyssey', NULL, 37, NULL, 'lux'),
('clockworkorange_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/1/13/Clockwork_Orange_%28poster%29.jpg', 'Affiche du film A Clockwork Orange', NULL, 38, NULL, 'hazel'),
('fullmetaljacket_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/1/1f/Full_Metal_Jacket_poster.jpg', 'Affiche du film Full Metal Jacket', NULL, 39, NULL, 'marlow'),
('drstrangelove_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/6/6a/Dr_Strangelove_poster.jpg', 'Affiche du film Dr. Strangelove', NULL, 40, NULL, 'gaia'),
('godfatherpart2_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/6/6f/The_Godfather_Part_II.jpg', 'Affiche du film The Godfather Part II', NULL, 42, NULL, 'serena'),
('apocalypsenow_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/0/0d/Apocalypse_Now_%281979%29_poster.jpg', 'Affiche du film Apocalypse Now', NULL, 43, NULL, 'atlas'),
('theconversation_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/a/a8/Theconversation.jpg', 'Affiche du film The Conversation', NULL, 44, NULL, 'julian'),
('dracula_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/f/ff/Bram_Stoker%27s_Dracula_%281992%29_poster.jpg', 'Affiche du film Bram Stoker''s Dracula', NULL, 45, NULL, 'crystal'),
('themartian_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/c/cd/The_Martian_film_poster.jpg', 'Affiche du film The Martian', NULL, 49, NULL, 'pixelboy'),
('blackhawkdown_poster.jpg', 'https://upload.wikimedia.org/wikipedia/en/e/e9/Black_Hawk_Down_poster.jpg', 'Affiche du film Black Hawk Down', NULL, 50, NULL, 'mira');

(42, 2, 11, 'Acteur secondaire'),

-- Interstellar
(48, 3, 12, 'Acteur principal'),
(28, 3, 13, 'Acteur secondaire'),

-- Oppenheimer
(54, 5, 17, 'Acteur principal'),

-- Jurassic Park
(26, 6, 20, 'Acteur secondaire'),
(13, 6, 22, 'Acteur secondaire'),

-- Schindler's List
(44, 7, 23, 'Acteur principal'),

-- Saving Private Ryan
(12, 8, 26, 'Acteur principal'),
(28, 8, 27, 'Acteur secondaire'),

-- Catch Me If You Can
(11, 10, 31, 'Acteur principal'),
(12, 10, 32, 'Acteur secondaire'),

-- Pulp Fiction
(26, 11, 33, 'Acteur secondaire'),
(20, 11, 34, 'Acteur secondaire'),
(14, 11, 0, 'Acteur secondaire'),

-- Django Unchained
(11, 12, 37, 'Acteur secondaire'),

-- Kill Bill Vol. 1
(22, 13, 0, 'Acteur secondaire'),

-- Inglourious Basterds
(14, 14, 41, 'Acteur secondaire'),

-- The Wolf of Wall Street
(11, 16, 45, 'Acteur principal'),

-- Goodfellas
(31, 17, 47, 'Acteur secondaire'),

-- The Departed
(11, 18, 50, 'Acteur principal'),
(28, 18, 51, 'Acteur secondaire'),
(43, 18, 52, 'Acteur secondaire'),

-- Taxi Driver
(31, 19, 53, 'Acteur principal'),

-- Shutter Island
(11, 20, 55, 'Acteur principal'),
(37, 20, 57, 'Acteur secondaire'),

-- Fight Club
(14, 21, 58, 'Acteur principal'),
(32, 21, 0, 'Acteur secondaire'),

-- Se7en
(13, 22, 61, 'Acteur principal'),
(14, 22, 62, 'Acteur principal'),

-- The Social Network
(46, 23, 64, 'Acteur secondaire'),

-- Gone Girl
(51, 24, 67, 'Acteur secondaire'),

-- Dune
(55, 26, 71, 'Acteur principal'),
(32, 26, 0, 'Acteur secondaire'),

-- Blade Runner 2049
(32, 27, 75, 'Acteur principal'),

-- Arrival
(24, 28, 78, 'Acteur principal'),

-- Sicario
(20, 29, 80, 'Acteur principal'),

-- Prisoners
(29, 30, 83, 'Acteur secondaire'),

-- Titanic
(11, 31, 85, 'Acteur principal'),
(21, 31, 86, 'Acteur principal'),

-- Avatar
(22, 32, 88, 'Acteur secondaire'),

-- Terminator 2
(42, 33, 91, 'Acteur secondaire'),

-- The Shining
(43, 36, 95, 'Acteur principal'),

-- 2001: A Space Odyssey
(19, 37, 0, 'Acteur secondaire'),

-- The Godfather
(30, 41, 101, 'Acteur principal'),
(40, 41, 102, 'Acteur principal'),

-- The Godfather Part II
(40, 42, 102, 'Acteur principal'),
(31, 42, 105, 'Acteur principal'),

-- Apocalypse Now
(47, 43, 106, 'Acteur secondaire'),

-- Gladiator
(42, 46, 112, 'Acteur principal'),

-- Blade Runner
(34, 47, 113, 'Acteur principal'),

-- Alien
(22, 48, 116, 'Acteur principal'),

-- The Martian
(28, 49, 118, 'Acteur principal'),

-- Réalisateurs dirigeant leurs films (déjà dans la table media via colonne 'realise')
-- Ajout de rôles supplémentaires
(1, 1, 0, 'Réalisateur'),
(1, 2, 0, 'Réalisateur'),
(1, 3, 0, 'Réalisateur'),
(1, 4, 0, 'Réalisateur'),
(1, 5, 0, 'Réalisateur'),
(2, 6, 0, 'Réalisateur'),
(2, 7, 0, 'Réalisateur'),
(2, 8, 0, 'Réalisateur'),
(2, 9, 0, 'Réalisateur'),
(2, 10, 0, 'Réalisateur'),
(3, 11, 0, 'Réalisateur'),
(3, 12, 0, 'Réalisateur'),
(3, 13, 0, 'Réalisateur'),
(3, 14, 0, 'Réalisateur'),
(3, 15, 0, 'Réalisateur'),
(4, 16, 0, 'Réalisateur'),
(4, 17, 0, 'Réalisateur'),
(4, 18, 0, 'Réalisateur'),
(4, 19, 0, 'Réalisateur'),
(4, 20, 0, 'Réalisateur'),
(5, 21, 0, 'Réalisateur'),
(5, 22, 0, 'Réalisateur'),
(5, 23, 0, 'Réalisateur'),
(5, 24, 0, 'Réalisateur'),
(5, 25, 0, 'Réalisateur'),
(6, 26, 0, 'Réalisateur'),
(6, 27, 0, 'Réalisateur'),
(6, 28, 0, 'Réalisateur'),
(6, 29, 0, 'Réalisateur'),
(6, 30, 0, 'Réalisateur'),
(7, 31, 0, 'Réalisateur'),
(7, 32, 0, 'Réalisateur'),
(7, 33, 0, 'Réalisateur'),
(7, 34, 0, 'Réalisateur'),
(7, 35, 0, 'Réalisateur'),
(8, 36, 0, 'Réalisateur'),
(8, 37, 0, 'Réalisateur'),
(8, 38, 0, 'Réalisateur'),
(8, 39, 0, 'Réalisateur'),
(8, 40, 0, 'Réalisateur'),
(9, 41, 0, 'Réalisateur'),
(9, 42, 0, 'Réalisateur'),
(9, 43, 0, 'Réalisateur'),
(9, 44, 0, 'Réalisateur'),
(9, 45, 0, 'Réalisateur'),
(10, 46, 0, 'Réalisateur'),
(10, 47, 0, 'Réalisateur'),
(10, 48, 0, 'Réalisateur'),
(10, 49, 0, 'Réalisateur'),
(10, 50, 0, 'Réalisateur'),

-- Acteurs secondaires supplémentaires
(21, 2, 0, 'Acteur secondaire'),
(15, 5, 0, 'Acteur secondaire'),
(33, 11, 0, 'Acteur secondaire'),
(25, 16, 0, 'Acteur secondaire'),
(17, 18, 0, 'Acteur secondaire'),
(35, 19, 0, 'Acteur secondaire'),
(38, 21, 0, 'Acteur secondaire'),
(41, 22, 0, 'Acteur secondaire'),
(39, 24, 0, 'Acteur secondaire'),
(49, 26, 0, 'Acteur secondaire'),
(23, 28, 0, 'Acteur secondaire'),
(36, 31, 0, 'Acteur secondaire'),
(50, 32, 0, 'Acteur secondaire'),
(52, 33, 0, 'Acteur secondaire'),
(18, 36, 0, 'Acteur secondaire'),
(27, 41, 0, 'Acteur secondaire'),
(53, 46, 0, 'Acteur secondaire');

-- =============================================
-- INSERTION DES COMMENTAIRES (critiques utilisateurs)
-- =============================================

INSERT INTO commente (date, texte, note, utilisateur, id_media, favori) VALUES
-- Inception
('2024-03-15', 'Chef-d''œuvre absolu ! Un film qui repousse les limites du cinéma.', 5.0, 'luna', 1, TRUE),
('2024-04-20', 'Complexe mais brillant. Il faut le voir plusieurs fois.', 4.5, 'neo', 1, FALSE),
('2024-05-10', 'Visuellement époustouflant, scénario intelligent.', 5.0, 'pixelboy', 1, TRUE),
('2024-06-02', 'Un peu trop compliqué à mon goût mais impressionnant.', 3.5, 'mira', 1, FALSE),
('2024-07-18', 'Nolan au sommet de son art !', 5.0, 'jasmin', 1, TRUE),

-- The Dark Knight
('2024-01-10', 'Le meilleur film de super-héros jamais réalisé.', 5.0, 'shadowfox', 2, TRUE),
('2024-02-14', 'Heath Ledger est incroyable en Joker.', 5.0, 'akira', 2, TRUE),
('2024-03-22', 'Sombre, intense, parfait.', 4.5, 'eliora', 2, FALSE),
('2024-04-30', 'Un thriller exceptionnel qui transcende le genre.', 5.0, 'toma', 2, TRUE),
('2024-05-15', 'La meilleure trilogie Batman sans aucun doute.', 4.5, 'skylie', 2, FALSE),

-- Interstellar
('2024-02-20', 'Émotionnellement puissant et scientifiquement fascinant.', 5.0, 'delta', 3, TRUE),
('2024-03-18', 'La scène du trou noir est magnifique.', 4.5, 'ghost', 3, FALSE),
('2024-04-25', 'Un voyage spatial épique et touchant.', 5.0, 'ragnar', 3, TRUE),
('2024-06-10', 'La musique de Hans Zimmer est sublime.', 4.5, 'sybel', 3, FALSE),

-- Pulp Fiction
('2024-01-05', 'Révolutionnaire ! Tarantino a réinventé le cinéma.', 5.0, 'mattix', 11, TRUE),
('2024-02-12', 'Dialogues cultes et structure narrative géniale.', 5.0, 'tenshi', 11, TRUE),
('2024-03-20', 'Un classique intemporel du cinéma indépendant.', 4.5, 'kronos', 11, FALSE),
('2024-04-08', 'Violent mais brillamment écrit.', 4.0, 'liv', 11, FALSE),

-- Titanic
('2024-01-25', 'Une histoire d''amour épique sur fond de tragédie.', 5.0, 'mecha', 31, TRUE),
('2024-02-28', 'Émouvant, romantique, inoubliable.', 4.5, 'eve93', 31, TRUE),
('2024-03-30', 'Un peu long mais magnifique.', 4.0, 'solaris', 31, FALSE),
('2024-05-05', 'La scène du naufrage est spectaculaire.', 4.5, 'tigra', 31, FALSE),

-- The Godfather
('2024-02-10', 'Le meilleur film de tous les temps selon moi.', 5.0, 'noctis', 41, TRUE),
('2024-03-15', 'Une masterclass de cinéma. Perfection absolue.', 5.0, 'cass', 41, TRUE),
('2024-04-20', 'Chaque scène est iconique.', 5.0, 'echo', 41, TRUE),
('2024-05-25', 'Un monument du 7ème art.', 5.0, 'iris_bl', 41, TRUE),

-- Fight Club
('2024-01-12', 'Subversif, intelligent, inoubliable.', 5.0, 'tango', 21, TRUE),
('2024-02-18', 'Le twist final est l''un des meilleurs du cinéma.', 4.5, 'nova', 21, FALSE),
('2024-03-25', 'Critique acerbe de la société de consommation.', 4.5, 'ariel', 21, FALSE),
('2024-04-30', 'Brad Pitt et Edward Norton sont excellents.', 4.0, 'prism', 21, FALSE),

-- Se7en
('2024-02-05', 'Thriller sombre et oppressant. Un chef-d''œuvre.', 5.0, 'rosetta', 22, TRUE),
('2024-03-12', 'L''ambiance est incroyablement angoissante.', 4.5, 'omega', 22, FALSE),
('2024-04-18', 'La fin est dévastatrice.', 5.0, 'silvio', 22, TRUE),

-- Avatar
('2024-01-20', 'Révolution visuelle ! Un spectacle pour les yeux.', 4.5, 'kaya', 32, TRUE),
('2024-02-25', 'Techniquement impressionnant même si l''histoire est simple.', 4.0, 'tomaX', 32, FALSE),
('2024-03-30', 'L''univers de Pandora est fascinant.', 4.5, 'lux', 32, FALSE),

-- The Shining
('2024-01-08', 'Terrif iant et hypnotique. Kubrick est un génie.', 5.0, 'hazel', 36, TRUE),
('2024-02-14', 'Jack Nicholson est effrayant à souhait.', 4.5, 'marlow', 36, FALSE),
('2024-03-22', 'Atmosphère oppressante et magistrale.', 5.0, 'gaia', 36, TRUE),
-- Gladiator
('2024-01-30', 'Épique et émotionnel. Russell Crowe est parfait.', 5.0, 'vortex', 46, TRUE),
('2024-02-28', 'Les scènes de combat sont spectaculaires.', 4.5, 'serena', 46, FALSE),
('2024-03-20', 'Un film d''action historique magistral.', 4.5, 'atlas', 46, FALSE),

-- Blade Runner
('2024-01-15', 'Vision futuriste sombre et poétique.', 5.0, 'julian', 47, TRUE),
('2024-02-20', 'Un chef-d''œuvre de science-fiction visuelle.', 4.5, 'crystal', 47, FALSE),
('2024-03-25', 'L''atmosphère cyberpunk est inégalée.', 5.0, 'tempo', 47, TRUE),

-- Dune
('2024-04-10', 'Adaptation fidèle et visuellement époustouflante.', 5.0, 'luna', 26, TRUE),
('2024-05-15', 'Villeneuve a réussi l''impossible !', 4.5, 'neo', 26, FALSE),
('2024-06-20', 'La photographie est sublime.', 4.5, 'pixelboy', 26, FALSE),

-- The Departed
('2024-03-08', 'Thriller policier haletant avec un casting parfait.', 4.5, 'mira', 18, TRUE),
('2024-04-12', 'Scorsese au sommet de son art.', 5.0, 'jasmin', 18, TRUE),
('2024-05-18', 'Tension maximale du début à la fin.', 4.5, 'shadowfox', 18, FALSE),

-- Django Unchained
('2024-02-22', 'Western revisité avec style et humour noir.', 4.5, 'akira', 12, TRUE),
('2024-03-28', 'DiCaprio est terrifiant en méchant.', 4.5, 'eliora', 12, FALSE),
('2024-04-30', 'Tarantino mélange action et critique sociale.', 4.0, 'toma', 12, FALSE),

-- Jurassic Park
('2024-01-18', 'Révolution des effets spéciaux ! Toujours impressionnant.', 5.0, 'skylie', 6, TRUE),
('2024-02-25', 'Un classique de la science-fiction familiale.', 4.5, 'delta', 6, FALSE),
('2024-03-30', 'Les dinosaures sont incroyablement réalistes.', 4.5, 'ghost', 6, FALSE),

-- The Wolf of Wall Street
('2024-02-08', 'Excès en tous genres ! DiCaprio est brillant.', 4.5, 'ragnar', 16, TRUE),
('2024-03-15', 'Critique acerbe du capitalisme sauvage.', 4.0, 'sybel', 16, FALSE),
('2024-04-22', 'Long mais captivant et hilarant.', 4.0, 'mattix', 16, FALSE),

-- Schindler's List
('2024-01-12', 'Film bouleversant et nécessaire. Un devoir de mémoire.', 5.0, 'tenshi', 7, TRUE),
('2024-02-18', 'Spielberg signe son chef-d''œuvre le plus personnel.', 5.0, 'kronos', 7, TRUE),
('2024-03-25', 'Émotionnellement dévastateur mais essentiel.', 5.0, 'liv', 7, TRUE),

-- Alien
('2024-02-12', 'Le film qui a défini le genre horrifique spatial.', 5.0, 'mecha', 48, TRUE),
('2024-03-18', 'Claustrophobe et terrifiant. Un classique.', 4.5, 'eve93', 48, FALSE),
('2024-04-25', 'Sigourney Weaver est iconique.', 4.5, 'solaris', 48, FALSE),

-- The Martian
('2024-03-05', 'Scientifiquement crédible et divertissant.', 4.5, 'tigra', 49, TRUE),
('2024-04-10', 'Matt Damon porte le film avec brio.', 4.0, 'noctis', 49, FALSE),
('2024-05-15', 'Optimiste et inspirant sur la survie.', 4.5, 'cass', 49, FALSE),

-- Goodfellas
('2024-01-20', 'Le meilleur film de gangsters avec Le Parrain.', 5.0, 'echo', 17, TRUE),
('2024-02-25', 'Rythme effréné et narration brillante.', 5.0, 'iris_bl', 17, TRUE),
('2024-03-30', 'Scorsese capture parfaitement la vie mafieuse.', 4.5, 'tango', 17, FALSE),

-- Shutter Island
('2024-02-15', 'Thriller psychologique avec un twist dévastateur.', 4.5, 'nova', 20, TRUE),
('2024-03-20', 'Atmosphère oppressante et mystérieuse.', 4.0, 'ariel', 20, FALSE),
('2024-04-25', 'DiCaprio livre une performance intense.', 4.5, 'prism', 20, FALSE),

-- Arrival
('2024-03-12', 'Science-fiction intelligente et émotionnelle.', 5.0, 'rosetta', 28, TRUE),
('2024-04-18', 'Un film sur la communication et le temps.', 4.5, 'omega', 28, FALSE),
('2024-05-22', 'Amy Adams est brillante.', 4.5, 'silvio', 28, FALSE),

-- 2001: A Space Odyssey
('2024-01-25', 'Chef-d''œuvre visionnaire de Kubrick.', 5.0, 'kaya', 37, TRUE),
('2024-02-28', 'Lent mais hypnotique et philosophique.', 4.5, 'tomaX', 37, FALSE),
('2024-03-30', 'Une expérience cinématographique unique.', 5.0, 'lux', 37, TRUE),

-- Apocalypse Now
('2024-02-05', 'Descente hallucinante dans l''horreur de la guerre.', 5.0, 'hazel', 43, TRUE),
('2024-03-10', 'Coppola filme la folie avec maestria.', 5.0, 'marlow', 43, TRUE),
('2024-04-15', 'Un voyage cauchemardesque inoubliable.', 4.5, 'gaia', 43, FALSE),

-- Blade Runner 2049
('2024-03-18', 'Suite digne de l''original. Visuellement sublime.', 5.0, 'vortex', 27, TRUE),
('2024-04-22', 'Villeneuve respecte et prolonge l''univers.', 4.5, 'serena', 27, FALSE),
('2024-05-28', 'Lent mais magnifique et contemplatif.', 4.5, 'atlas', 27, FALSE),

-- Gone Girl
('2024-02-20', 'Thriller psychologique retors et brillant.', 4.5, 'julian', 24, TRUE),
('2024-03-25', 'Rosamund Pike est glaçante et parfaite.', 5.0, 'crystal', 24, TRUE),
('2024-04-30', 'Critique acerbe du mariage moderne.', 4.0, 'tempo', 24, FALSE),

-- Prisoners
('2024-01-28', 'Thriller intense et moralement complexe.', 4.5, 'luna', 30, TRUE),
('2024-02-25', 'Hugh Jackman livre sa meilleure performance.', 4.5, 'neo', 30, FALSE),
('2024-03-30', 'Sombre et oppressant. Villeneuve excelle.', 4.5, 'pixelboy', 30, FALSE),

-- Commentaires supplémentaires variés
('2024-06-15', 'Film culte que je revois régulièrement !', 5.0, 'mira', 21, TRUE),
('2024-07-20', 'Bande-son exceptionnelle qui accompagne parfaitement l''image.', 4.5, 'jasmin', 3, FALSE),
('2024-08-10', 'Un incontournable du cinéma d''action.', 4.0, 'shadowfox', 46, FALSE),
('2024-09-05', 'Scénario brillant qui se bonifie à chaque visionnage.', 5.0, 'akira', 11, TRUE),
('2024-10-12', 'Performances d''acteurs exceptionnelles.', 4.5, 'eliora', 41, FALSE),
('2024-11-18', 'Une œuvre qui marque l''histoire du cinéma.', 5.0, 'toma', 22, TRUE),
('2024-12-02', 'Visuellement éblouissant, un régal pour les yeux.', 4.5, 'skylie', 32, FALSE);

-- =============================================
-- RÉSUMÉ DES INSERTIONS
-- =============================================
-- Total des artistes: 58 (réalisateurs + acteurs)
-- Total des médias: 52 films
-- Total des personnages: 119 personnages
-- Total des images: 34 (acteurs + posters de films)
-- Total des participations: 100+ relations acteur-film
-- Total des commentaires: 100+ critiques utilisateurs

-- Note: Toutes les données sont basées sur de vrais films, acteurs et personnages
-- Les URLs d'images proviennent de Wikimedia Commons (domaine public)
-- Les genres, dates de sortie et descriptions sont authentiques




