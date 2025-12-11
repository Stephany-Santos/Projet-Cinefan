import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))
import db

def all_infos(commande):
    '''
    à remplir
    '''
    conn = None
    try:
        conn = db.connect()
        cur = conn.cursor()
        cur.execute(commande)

        lignes = cur.fetchall()
        colonnes = [e[0] for e in cur.description]
        
        infos = []
        for row in lignes:
            info = {colonnes[i]: row[i] for i in range(len(colonnes))}
            infos.append(info)
        return infos
    
    except Exception as e:
        return f"Erreur BDD : {e}", 500
    finally:
        if conn:
            conn.close()


def all_media():
    '''
    à remplir
    '''
    return all_infos("""
        SELECT DISTINCT
            m.id_media AS id,
            m.titre, m.description,
            m.parution, m.type, m.genre,
            i.fichier AS nom_image,
            i.lien AS url_image,
            i.alt AS alt
        FROM media m
        LEFT JOIN image i ON m.id_media = i.media;
    """)


def infos_media(media_id):
    '''
    Récupère les infos d'un media spécifique
    Arguments:
        ...
    Return:
        ...
    '''
    return all_infos(f"""
        SELECT
            m.id_media AS id,
            m.titre, m.description,
            m.parution, m.type, m.genre,
            i.fichier AS nom_image,
            i.lien AS url_image,
            i.alt AS alt
        FROM media m
        LEFT JOIN image i ON m.id_media = i.media
        WHERE m.id_media = {media_id};
    """)


# def getfilm(titre):
#     '''
#     Fonction renvoyant un dictionnaire contenant les informations nécessaires pour un film
#     Arguments:
#         titre (str): Le titre du film à rechercher
#     Return:
#         item (dict): dictionnaire des informations du film
#     '''
#     all = all_media()
#     for item in all:
#         if item == titre:
#             return item
        
def favs(pseudo): #UNFINISHED
    '''
    Récupère les médias favoris d'un utilisateur à partir de son pseudo
    Arguments:
        pseudo (str): Le pseudo de l'utilisateur
    Return:
        favoris (dict): dico des médias favoris
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
                final[item] = all_media(item)
    return final

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

def comms(user):
    '''
    Fonction récupérant les commentaires laissés par un utilisateur
    '''
    request = ("""select id_media, note, texte, date
                from commente
                where utilisateur = %s""", (user,))
    