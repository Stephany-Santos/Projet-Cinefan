import psycopg2
import psycopg2.extras

def connect():
  conn = psycopg2.connect(
    dbname = 'postgres',
    user = 'postgres',
    password = "mdp",
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.set_client_encoding('UTF8')
  conn.autocommit = True
  return conn
