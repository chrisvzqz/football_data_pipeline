from src.config.settings import POSTGRES_PASSWORD, POSTGRES_USER, POSTGRES_HOST, POSTGRES_PORT, POSTGRES_NAME
import psycopg2

def get_connection():
    return psycopg2.connect(database=POSTGRES_NAME,
                            user = POSTGRES_USER,
                            host = POSTGRES_HOST,
                            password = POSTGRES_PASSWORD,
                            port = POSTGRES_PORT)