SET client_encoding to UTF8;


CREATE TABLE genre (
    intitule VARCHAR(50) PRIMARY KEY,
    description TEXT
);

INSERT INTO genre (intitule, description) VALUES
('Action', 'Films et séries avec des scènes d''action intenses, combats et cascades'),
('Horreur', 'Œuvres conçues pour effrayer et créer une atmosphère de tension'),
('Psychologique', 'Récits explorant la psyché humaine, les troubles mentaux et les manipulations'),
('Action-Horreur', 'Combinaison d''action intense et d''éléments horrifiques'),
('Thriller Psychologique', 'Suspense basé sur la manipulation mentale et les jeux psychologiques'),
('Science-Fiction', 'Univers futuristes, technologies avancées et explorations spatiales'),
('Fantasy', 'Mondes imaginaires avec magie, créatures surnaturelles et quêtes héroïques');
