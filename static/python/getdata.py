import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))
import db

def all_infos(commande):
    '''
    Fonction qui crée une liste de dictionnaires contenant les informations renvoyées
    par commande
    Arguments :
        commande : la requête SQL à exécuter
    Retour :
        Liste de dictionnaires avec les résultats, ou tuple (erreur, code)
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
        # print(infos)
        return infos
    
    except Exception as e:
        return f"Erreur BDD : {e}", 500
    finally:
        if conn:
            conn.close()


def all_media():
    '''
    Récupère TOUS les médias de la base de données
    Arguments : aucun
    Retour :
        Liste de dictionnaires avec tous les médias
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
        media_id: l'ID du media à récupérer
    Return:
        Liste contenant un dictionnaire avec les infos du media
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

def search_all(terme):
    '''
    Recherche dans tous les types : médias, artistes, personnages
    Arguments:
        terme: le terme de recherche
    Return:
        Liste de dictionnaires avec tous les résultats mélangés
    '''
    resultats = []

    medias = all_infos(f"""
        SELECT DISTINCT
            m.id_media AS id,
            m.titre, m.description,
            m.parution, m.type, m.genre,
            i.fichier AS nom_image,
            i.lien AS url_image,
            i.alt AS alt,
            'media' AS type_resultat
        FROM media m
        LEFT JOIN image i ON m.id_media = i.media
        WHERE LOWER(m.titre) LIKE LOWER('%{terme}%')
        ORDER BY m.titre ASC;
    """)

    artistes = all_infos(f"""
        SELECT DISTINCT
            a.id_artiste AS id,
            a.nom, a.prenom,
            'artiste' AS type_resultat
        FROM artiste a
        WHERE LOWER(a.nom) LIKE LOWER('%{terme}%') OR LOWER(a.prenom) LIKE LOWER('%{terme}%')
        ORDER BY a.nom ASC, a.prenom ASC;
    """)

    personnages = all_infos(f"""
        SELECT DISTINCT
            p.id_perso AS id,
            p.nom, p.prenom,
            p.description,
            m.titre,
            'personnage' AS type_resultat
        FROM personnage p
        JOIN media m ON p.media = m.id_media
        WHERE LOWER(p.nom) LIKE LOWER('%{terme}%') OR LOWER(p.prenom) LIKE LOWER('%{terme}%')
        ORDER BY p.nom ASC, p.prenom ASC;
    """)

    if isinstance(medias, list):
        resultats.extend(medias)
    if isinstance(artistes, list):
        resultats.extend(artistes)
    if isinstance(personnages, list):
        resultats.extend(personnages)

    return resultats

def personnage_infos(media_id):
    '''
    Personnages d'un film + acteur qui les interprète (sans "Prénom Sans"),
    d'abord acteurs principaux puis secondaires.
    '''
    return all_infos(f"""
        SELECT
            p.id_perso,
            p.nom AS perso_nom,
            p.prenom AS perso_prenom,
            p.description AS perso_description,
            a.id_artiste AS id_artiste,
            a.nom AS artiste_nom,
            a.prenom AS artiste_prenom,
            pa.role AS participation_role
        FROM personnage p
        JOIN participe pa ON pa.id_perso = p.id_perso
        JOIN artiste   a  ON pa.id_artiste = a.id_artiste
        WHERE pa.id_media = {media_id} AND LOWER(pa.role) LIKE 'acteur%%'
        ORDER BY 
            CASE 
                WHEN LOWER(pa.role) = 'acteur principal' THEN 0
                WHEN LOWER(pa.role) = 'acteur secondaire' THEN 1
                ELSE 2
            END,
            a.nom ASC, a.prenom ASC;
    """)


def realisateurs_media(media_id):
    '''
    Réalisateur(s) d'un film à partir de media.realise.
    '''
    return all_infos(f"""
        SELECT
            a.id_artiste,
            a.nom,
            a.prenom
        FROM media m
        JOIN artiste a ON m.realise = a.id_artiste
        WHERE m.id_media = {media_id};
    """)


def typeMedia():
    '''
    Fonction récupérant tout les types différents de médias'''
    lst = all_infos("""select distinct type from media""")
    return lst


def genre():
    '''
    Fonction récupérant tout les types différents de genre'''
    return all_infos("""select intitule from genre""")

def artiste():
    '''
    Fonction récupérant tout les noms d'artistes
    '''
  return all_infos("""select nom, prenom, id_artiste from artiste""")

def persos():
    '''Fonction récupérant tout les personnages'''
    lst = all_infos("""select * from personange""")
    return lst

def favs(pseudo): #UNFINISHED
    '''
    Récupère les médias favoris d'un utilisateur à partir de son pseudo
    Arguments:
        pseudo (str): Le pseudo de l'utilisateur
    Return:
        favoris (dict): dico des médias favoris
    '''
    titres = all_infos(f"""select media.id_media from media NATURAL JOIN commente 
                        where commente.utilisateur = '{pseudo}'
                        and commente.favori = TRUE """)
    return [infos_media(id['id_media']) for id in titres]

def info_user(user_pseudo):
    '''
    Récupère les informations d'un utilisateur à partir de son pseudo
    Arguments:
        user_pseudo (str): Le pseudo de l'utilisateur
    Return:
        dictionnaire des informations de l'utilisateur
    '''
    return all_infos(f"""
        SELECT pseudo, mdp, nom, biographie 
        FROM utilisateur
        WHERE pseudo = '{user_pseudo}'
    """)

def commUser(pseudo):
    '''
    Fonction récupérant les commentaires laissés par un utilisateur
    '''
    lst = all_infos(f"""select id_media, media.titre, commente.note, commente.texte, commente.date, commente.favori
                from commente natural join media
                where utilisateur = '{pseudo}'""")
    toRemove = []
    for comm in lst:
        if comm['texte'] == None or comm['texte'] == '':
            toRemove.append(comm)
    for rem in toRemove:
        lst.remove(rem)
    return lst
    
def activityUser(pseudo):
    '''Fonction récupérant les ajouts faits par un utilisateur'''
    lst1 = all_infos(f"""select m.titre, m.id_media as id
                    from media as m
                    where m.cree_par = '{pseudo}'""")
    lst2 = all_infos(f"""
                    select CONCAT(p.nom, ' ', p.prenom) as titre, p.id_perso as id
                    from personnage as p
                    where p.cree_par = '{pseudo}'""")
    lst3 = all_infos(f"""select CONCAT(a.nom, ' ', a.prenom) as titre, a.id_artiste as id
                    from artiste as a
                    where a.cree_par = '{pseudo}'
                    """)

    dico = {}
    if lst1!=[]:
        dico['media']=lst1
    
    if lst2!=[]:
        dico['perso']=lst2
    
    if lst3!=[]:
        dico['artiste']=lst3
    print(dico)
    return dico

def commMedia(id):
    '''
    Fonction récupérant les commentaires laissés sur un media
    Argument - id (int) : id_media
    '''
    lst = all_infos(f"""select id_media, commente.utilisateur, commente.note, commente.texte, commente.date, commente.favori
                from commente natural join media
                where id_media = '{id}'
                order by commente.date desc""")
    toRemove = []
    for comm in lst:
        if comm['texte'] == None or comm['texte'] == '':
            toRemove.append(comm)
    for rem in toRemove:
        lst.remove(rem)
    return lst

def genComms():
    '''
    Fonction récupérant tout les commentaires triés par ordre chronologique
    '''
    lst = all_infos("""select * from commente natural join media
                    order by commente.date desc""")
    toRemove = []
    for comm in lst:
        if comm['texte'] == None or comm['texte'] == '':
            toRemove.append(comm)
    for rem in toRemove:
        lst.remove(rem)
    return lst

def artisteMedia(idMedia):
    '''Fonction récupérant les artistes ayant participé à tel média'''
    return all_infos(f"""select * from participe natural join  artiste
                    where participe.id_media = {idMedia}""")

def artisteRole():
    '''Fonction récupérant les différents rôles des artistes'''
    return all_infos("""select distinct role from participe""")

def derniersAjouts():
    '''
    Fonction récupérant les derniers médias ajoutés
    '''
    lst = all_infos("""select * from media
                    order by id_media desc
                    limit 30""")
    return lst

def derniersAjoutsImg():
    '''
    Fonction récupérant les derniers médias ajoutés
    '''
    return all_infos("""select m.id_media AS id,
                    m.titre as titre,
                    m.creer_par as mediaCreer, i.creer_par as imgCreer,
                    i.alt as alt, i.lien as lien
                    from media as m
                    left join image as i on m.id_media = i.media
                    order by m.id_media desc
                    limit 30""")