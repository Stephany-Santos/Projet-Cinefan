SET client_encoding to UTF8;

DROP TABLE IF EXISTS media CASCADE;
DROP TABLE IF EXISTS genre CASCADE;

CREATE TABLE media (
    id_media SERIAL PRIMARY KEY,
    titre VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parution DATE,
    type VARCHAR(50) NOT NULL
);

INSERT INTO media (titre, description, parution, type) VALUES
('Voyage Stellaire', 'Un équipage se lance dans l''espace.', '2023-03-01', 'film'),
('Le Royaume Caché', 'Un jeune garçon découvre un monde secret.', '2022-10-15', 'film'),
('Animaliens', 'Une planète habitée par des animaux animés.', '2024-04-20', 'série'),
('CyberNet', 'Un hacker lutte contre une IA malveillante.', '2023-06-11', 'film'),
('L Énigme du Temps', 'Un détective résout des mystères temporels.', '2024-02-18', 'film');