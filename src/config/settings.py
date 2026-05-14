from dotenv import load_dotenv
import os

load_dotenv()

API_KEY = os.getenv("FOOTBALL_API_KEY")
POSTGRES_PASSWORD = os.getenv("DB_PASSWORD")
POSTGRES_USER = os.getenv("DB_USER")
POSTGRES_HOST = os.getenv("DB_HOST")
POSTGRES_PORT = os.getenv("DB_PORT")
POSTGRES_NAME = os.getenv("DB_NAME")