import psycopg2
import psycopg2.extras
import db

def media(titre):
    '''
    Récupère les informations d'un média à partir de son titre
    Arguments:
        titre (str) ou (int): Le titre du média à rechercher OU son identifiant
    Return:
    '''
    with db.connect as conn:
        with conn.cursor() as cur:
            if type(titre) is str:
                cur.execute(f'select * from media where titre = {titre}')
            elif type(titre) is str:
                cur.execute(f'select * from media where id_media = {titre}')
            else:
                pass #Trouver une façon de dire que l'on a pas trouvé le media
            resultat = cur.fetchone()
    return resultat

if __name__ == "__main__":
    print(media("Inception"))


# -- Pour chaque acteur, le nombre de films de chaque genre dans lesquels il a joué,
# -- trié par nombre de films descendant.
# CREATE VIEW filmsParActeur AS (
#     SELECT a.nom, a.prenom, m.genre, COUNT(*) AS nombreDeFilms
#     FROM artiste a
#     JOIN participe p ON p.id_artiste = a.id
#     JOIN media m ON m.id_media = p.id_media
#     GROUP BY a.nom, a.prenom, m.genre;
# )

# -- le nombre de critiques écrites par chaque membre du club.

# CREATE VIEW nbCritiques AS (
#     SELECT utilisateur.pseudo, COUNT(commente.utilisateur) AS nombreDeCritiques
#     FROM utilisateur
#     LEFT JOIN commente ON utilisateur.pseudo = commente.utilisateur
#     GROUP BY utilisateur.pseudo
# )

# -- Le nombre moyen de critiques écrites par utilisateur pour chaque genre.

# CREATE VIEW moyenneCritiques AS (
#     SELECT media.genre, AVG(nbCritiques.nombreDeCritiques) AS moyenneCritiquesParGenre
#     FROM media
#     JOIN commente ON media.id_media = commente.id_media
#     JOIN nbCritiques ON commente.utilisateur = nbCritiques.pseudo
#     GROUP BY media.genre
# )