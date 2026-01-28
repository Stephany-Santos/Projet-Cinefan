import psycopg2
import psycopg2.extras
import os

def connect():
  conn = psycopg2.connect(
    # ---- using remote database
    host="dpg-d5sv4j75r7bs73bai5l0-a",
    dbname="cinefandb",
    user="cinefandb_user",
    password="kRGteTX0EQ4caE4XXZw2SeXMdx5yJy0A",
    port=5432,
    # ---- using local database
    # dbname = 'postgres',
    # user = 'postgres',
    # password = "",
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.set_client_encoding('UTF8')
  conn.autocommit = True
  return conn
