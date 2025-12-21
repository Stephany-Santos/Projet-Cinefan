import static.python.getdata as get

def critiques_per_user(pseudo):
    '''
    Récupère le nombre de critiques écrites par chaque membre du club.
    Arguments:
        user (str): Le pseudo de l'utilisateur
    Return:
        int: Le nombre de critiques écrites par l'utilisateur
    '''
    return get.all_infos(f"""SELECT COUNT(commente.utilisateur) AS nombreDeCritiques
                         FROM utilisateur LEFT JOIN commente ON utilisateur.pseudo = commente.utilisateur
                         WHERE utilisateur = '{pseudo}'
                         GROUP BY utilisateur.pseudo""")

def critiques_per_genre(pseudo):
    '''
    Récupère le nombre de critiques écrites par chaque membre du club pour chaque genre.
    Arguments:
        user (str): Le pseudo de l'utilisateur
    Return:
        list of dict: Liste des genres et du nombre de critiques écrites par l'utilisateur pour chaque genre
    '''
    return get.all_infos(f"""SELECT media.genre, COUNT(commente.utilisateur) AS nombreDeCritiques
                         FROM utilisateur
                         LEFT JOIN commente ON utilisateur.pseudo = commente.utilisateur
                         LEFT JOIN media ON commente.id_media = media.id_media
                         WHERE utilisateur.pseudo = '{pseudo}'
                         GROUP BY media.genre
                         ORDER BY nombreDeCritiques DESC
                         LIMIT 1""")

def genrePref(pseudo):
    '''
    Récupère le genre préféré d'un utilisateur en fonction du nombre de critiques écrites.
    Arguments:
        user (str): Le pseudo de l'utilisateur
    Return:
        dict: Le genre préféré et le nombre de critiques écrites pour ce genre
    '''
    result = get.all_infos(f"""SELECT mg.intitule_genre, ROUND(AVG(c.note), 1) as moyenne_note
                            FROM commente c
                            JOIN media m ON c.id_media = m.id_media
                            JOIN media_genre mg ON m.id_media = mg.id_media
                            WHERE c.utilisateur = '{pseudo}' 
                            GROUP BY mg.intitule_genre
                            ORDER BY moyenne_note DESC
                            LIMIT 1;
                            """)
    return result[0] if result else None

def calcul_badge_activite(pseudo):
    nb_comms = len(get.commUser(pseudo))
<<<<<<< HEAD
    # print(f"{get.commUser(pseudo)} : {nb_comms}")
    nb_favs = len(get.favs(pseudo))
    # print(f"{get.favs(pseudo)} : {nb_favs}")
    activite = get.activityUser(pseudo)
    # print(f"{get.activityUser(pseudo)} : {activite}")
=======
    nb_favs = len(get.favs(pseudo))
    activite = get.activityUser(pseudo)
>>>>>>> 42705a222b260a8f7ee42bb7cfb80b0db2d9c8d3
    nb_ajouts = sum(len(v) for v in activite.values()) if activite else 0

    total = nb_comms + nb_favs + nb_ajouts

    if total >= 50:
        return {"emoji": "🏆", "label": "Meilleur contributeur.ice"}
    elif total >= 25:
        return {"emoji": "🔥", "label": "Très actif.ve"}
    elif total >= 10:
        return {"emoji": "✨", "label": "Actif.ve"}
    elif total >= 1:
        return {"emoji": "🌱", "label": "Peu actif.ve"}
    else:
        return {"emoji": "💤", "label": "Pas très actif.ve"}

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