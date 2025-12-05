#	-------- Projet CINEFAN -------
#              TP 12
#    par Flore Rigoigne, Niekita Joseph
#   et Stephany Santos Ferreira de Sousa
#     -------------------------------

# ------------ Imports
import random
import time
from flask import Flask, render_template, request, redirect, url_for, session

import db

# ------------ Fonction Application Flask


app = Flask(__name__)

if __name__ == '__main__':
    app.run()

@app.route("/listemedia")
def listemedia():
    # Connexion à la base et récupération des médias
    conn = db.connect()
    cur = conn.cursor()
    cur.execute("""
        SELECT m.id_media, m.titre, m.parution, m.genre, m.type,
               a.nom AS real_nom, a.prenom AS real_prenom
        FROM media m
        JOIN artiste a ON m.realise = a.id_artiste
        ORDER BY m.parution DESC
    """)
    result = cur.fetchall()
    cur.close()
    conn.close()

    return render_template("medialiste.html", medialiste=result)
