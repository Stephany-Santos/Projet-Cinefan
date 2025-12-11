import psycopg2
import psycopg2.extras
import db as db

def critiques_per_user(user):
    '''
    Récupère le nombre de critiques écrites par chaque membre du club.
    Arguments:
        user (str): Le pseudo de l'utilisateur
    Return:
        int: Le nombre de critiques écrites par l'utilisateur
    '''
    with db.connect as conn:
        with conn.cursor() as cur:
            cur.execute('SELECT utilisateur.pseudo, COUNT(commente.utilisateur) AS nombreDeCritiques FROM utilisateur LEFT JOIN commente ON utilisateur.pseudo = commente.utilisateur WHERE utilisateur = %s GROUP BY utilisateur.pseudo', (user,))
            resultat = cur.fetchone()
    return resultat[0]


# -- Pour chaque acteur, le nombre de films de chaque genre dans lesquels il a joué,
# -- trié par nombre de films descendant.
# CREATE VIEW filmsParActeur AS (
#     SELECT a.nom, a.prenom, m.genre, COUNT(*) AS nombreDeFilms
#     FROM artiste a
#     JOIN participe p ON p.id_artiste = a.id
#     JOIN media m ON m.id_media = p.id_media
#     GROUP BY a.nom, a.prenom, m.genre;
# )


# -- Le nombre moyen de critiques écrites par utilisateur pour chaque genre.

# CREATE VIEW moyenneCritiques AS (
#     SELECT media.genre, AVG(nbCritiques.nombreDeCritiques) AS moyenneCritiquesParGenre
#     FROM media
#     JOIN commente ON media.id_media = commente.id_media
#     JOIN nbCritiques ON commente.utilisateur = nbCritiques.pseudo
#     GROUP BY media.genre
# )