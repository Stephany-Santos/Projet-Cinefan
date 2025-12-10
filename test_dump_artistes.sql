SET client_encoding to UTF8;

CREATE TABLE artiste (
    id_artiste SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100) NOT NULL,
    cree_par VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT NOT NULL
);



INSERT INTO artiste (nom, prenom, cree_par) VALUES

-- Réalisateurs célèbres
('Nolan', 'Christopher', 'alice'),
('Spielberg', 'Steven', 'alice'),
('Tarantino', 'Quentin', 'bob42'),
-- Acteurs principaux
('DiCaprio', 'Leonardo', 'luna'),
('Hanks', 'Tom', 'luna'),
('Freeman', 'Morgan', 'neo'),
('Pitt', 'Brad', 'luna'),
('Cruise', 'Tom', 'pixelboy'),
('Gadot', 'Gal', 'tempo');
