from src.db.connection import get_connection

conn = get_connection()

cur = conn.cursor()
cur.execute("SELECT COUNT(*) FROM matches;")
rows = cur.fetchall()
conn.commit()
conn.close()
for row in rows:
    print(row)

# cur = conn.cursor()
# cur.execute("""
#             DELETE FROM matches""")
# conn.commit()
# cur.close()