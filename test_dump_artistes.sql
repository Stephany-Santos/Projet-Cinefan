

CREATE TABLE artiste (
    id_artiste SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100) NOT NULL,
    cree_par VARCHAR(20) DEFAULT 'deleted-user' REFERENCES utilisateur(pseudo) ON DELETE SET DEFAULT NOT NULL
);
