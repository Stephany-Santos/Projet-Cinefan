import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))
import db

def getmedia(titre):
    '''
    Récupère les informations d'un média à partir de son titre
    Arguments:
        titre (str) ou (int): Le titre du média à rechercher OU son identifiant
    Return:
    '''
    with db.connect() as conn:
        with conn.cursor() as cur:
            if type(titre) is str:
                cur.execute(f'select * from media where titre = {titre}')
            elif type(titre) is str:
                cur.execute(f'select * from media where id_media = {titre}')
            else:
                pass #Trouver une façon de dire que l'on a pas trouvé le media
            resultat = cur.fetchone()
    return resultat

def getfilm(titre):
    all = getmedia()
    for item in all:
        if item == titre:
            return titre
        
def favs(pseudo):
    '''
    Récupère les médias favoris d'un utilisateur à partir de son pseudo
    Arguments:
        pseudo (str): Le pseudo de l'utilisateur
    Return:
        liste des médias favoris
    '''
    favoris = []
    final = {}
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("""select media.titre from media NATURAL JOIN commente 
                        where commente.utilisateur = %s
                        and commente.favori = TRUE""", (pseudo,))
            for record in cur.fetchall():
                favoris.append(record)
            for item in favoris: #in favoris, u got id_medias
                final[item] = getmedia(item)
    return favoris

def user(user):
    '''
    Récupère les informations d'un utilisateur à partir de son pseudo
    Arguments:
        pseudo (str): Le pseudo de l'utilisateur
    Return:
        dictionnaire des informations de l'utilisateur
    '''
    with db.connect() as conn:
    
        with conn.cursor() as cur:
                cur.execute(""" select pseudo, mdp, nom, biographie from utilisateur
                            where pseudo = %s
                            or mail = %s""", (user, user,))
                temp = []
                for record in cur.fetchone():
                    temp.append(record)
    return {'pseudo': temp[0], 'mdp': temp[1], 'nom': temp[2], 'bio': temp[3]}
