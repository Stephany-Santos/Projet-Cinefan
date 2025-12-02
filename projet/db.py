import psycopg2
import psycopg2.extras

def connect():
	conn = psycopg2.connect(
		dbname = "niekita;joseph",
		cursor_factory = psycopg2.extras.NamedTupeCursor
	)
	conn.autocommit = True
	return conn

# Fichier dans lequel on pourra créer des fonctions filtres (tout nos select etc) à afficher sur le site

	 
@app.route("/listemedia")
def listemedia():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT m.id_media, m.titre, m.parution, m.genre, m.type,
                       a.nom AS real_nom, a.prenom AS real_prenom
                FROM media m
                JOIN artiste a ON m.realise = a.id_artiste
                ORDER BY m.parution DESC
            """)
            result = cur.fetchall()
    return render_template("medialiste.html", medialiste=result)
