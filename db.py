import psycopg2
import psycopg2.extras
import os

def connect():
  conn = psycopg2.connect(
    # ---- using remote database
    url = os.environ["CINEFANDATABASE_URL"],
    # ---- using local database
    # dbname = 'postgres',
    # user = 'postgres',
    # password = "",
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.set_client_encoding('UTF8')
  conn.autocommit = True
  return conn
