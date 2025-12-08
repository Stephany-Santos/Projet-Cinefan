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


