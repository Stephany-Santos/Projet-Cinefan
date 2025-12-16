#changement pages genres

# changements dossier main.py

@app.route("/genres")
def genres():
    themes = get_themes(limit=5)       # Thèmes de séances cinéma
    top_consultes = get_top_genres(limit=5)  # Genres les plus consultés
    genres = all_genres()              # Tous les genres

    return render_template(
        "genre.html",
        categories=themes,
        top_consultes=top_consultes,
        genres=genres,
        UserConnecte=user_connected()
    )

@app.route("/genres/<genre_name>")
def genre_detail(genre_name):
    return render_template(
        "genre_detail.html",
        genre=genre_name,
        medias=medias_by_genre(genre_name),
        UserConnecte=user_connected()
    )


# changements dossier getdata.py


def all_genres():
    """Retourne tous les genres"""
    return all_infos("SELECT intitule, description FROM genre ORDER BY intitule;")

def get_themes(limit=5):
    """Renvoie les thèmes de séances cinéma à afficher"""
    return all_infos(f"""
        SELECT intitule, description
        FROM genre
        ORDER BY intitule
        LIMIT {limit};
    """)

def get_top_genres(limit=5):
    """Renvoie les genres les plus consultés par les utilisateurs"""
    return all_infos(f"""
        SELECT m.genre AS intitule, COUNT(*) AS nb_consultes
        FROM commente c
        JOIN media m ON c.id_media = m.id_media
        GROUP BY m.genre
        ORDER BY nb_consultes DESC
        LIMIT {limit};
    """)

def medias_by_genre(genre_name):
    """Retourne tous les médias d’un genre spécifique"""
    return all_infos(f"""
        SELECT id_media AS id, titre, description, parution, type
        FROM media
        WHERE genre = '{genre_name}';
    """)

   # code html 





#changement page statistiques

# commandes sql

# Nombreux moyen d'artistes par film :

# SELECT AVG(nb_artistes) AS moyenne_artistes
# FROM (
#     SELECT m.id, COUNT(DISTINCT p.id_artiste) AS nb_artistes
#     FROM media m
#     LEFT JOIN participe p ON m.id = p.id_media
#     WHERE m.type = 'film'
#     GROUP BY m.id
# ) AS stats;


# Nombreux moyen de films realisés par un artiste

# SELECT a.id, a.nom, a.prenom, COUNT(m.id) AS nb_films
# FROM artiste a
# JOIN media m ON m.realise = a.id
# WHERE m.type = 'film'
# GROUP BY a.id, a.nom, a.prenom;

# Nombreux moyen de commentaires par film 



# SELECT AVG(nb_commentaires) AS moyenne_commentaires
# FROM (
#     SELECT m.id, COUNT(c.id_media) AS nb_commentaires
#     FROM media m
#     LEFT JOIN commente c ON m.id = c.id_media
#     WHERE m.type = 'film'
#     GROUP BY m.id
# ) AS stats;

