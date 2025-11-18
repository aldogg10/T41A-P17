import psycopg2
import pytest

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

def run_query(query):
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            return cur.fetchall()

def test_marca_laptop():
    result = run_query("SELECT atributos -> 'marca' FROM productos WHERE nombre = 'Laptop';")
    assert result[0][0] == "Dell"

def test_color_telefono():
    result = run_query("SELECT atributos -> 'color' FROM productos WHERE nombre = 'Teléfono';")
    assert result[0][0] == "Negro"

def test_ram_laptop():
    result = run_query("SELECT atributos -> 'ram' FROM productos WHERE nombre = 'Laptop';")
    assert result[0][0] == "16GB"
