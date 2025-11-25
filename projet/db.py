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