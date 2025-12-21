from flask import Flask, render_template
import os
import db as db

app = Flask(__name__)

films = [
    {"id": 1, "titre": "Inception", "genre": "Sci-Fi", "annee": 2010},
    {"id": 2, "titre": "The Matrix", "genre": "Action", "annee": 1999},
    {"id": 3, "titre": "Interstellar", "genre": "Sci-Fi", "annee": 2014},
]

# Liste des médias
@app.route("/Test")
def mediaList():
  with db.connect() as conn:
    with conn.cursor() as cur:
      cur.execute("select id_media, titre, description, parution from media")
      result = cur.fetchall()
  return render_template("test_db.html", list = result)

# à changer avec des liens et pas récupérer les images dans les fichiers 🥲
@app.route('/')
def accueil():
    for film in films:
        nom_image = film["titre"].replace(" ", "") + ".jpg"
        chemin_image = os.path.join(app.static_folder, "images", nom_image)
        if os.path.exists(chemin_image):
            film["image"] = f"images/{nom_image}"
        else:
            film["image"] = None
    return render_template('accueil.html', films=films)

# de même
@app.route('/film/<int:film_id>')
def film_detail(film_id):
    film = next((f for f in films if f["id"] == film_id), None)
    if film:
        nom_image = film["titre"].replace(" ", "") + ".jpg"
        chemin_image = os.path.join(app.static_folder, "images", nom_image)
        if os.path.exists(chemin_image):
            film["image"] = f"images/{nom_image}"
        else:
            film["image"] = None
    return render_template('film.html', film=film)

if __name__ == '__main__':
    app.run(debug=True)
