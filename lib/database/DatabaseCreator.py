# Let's write a Python script to insert a single user into the database.
import json
import random
import sqlite3
import string
import sqlite3

# Adjusting the table name from 'User' to 'usr' to avoid conflicts with SQL keywords and to follow the user's request.

import sqlite3
import json

# Define the database and json file names
db_file = 'simple_db.db'
json_file = 'simple_db.json'

# Connect to the SQLite database
conn = sqlite3.connect(db_file)
c = conn.cursor()

# Create the usr table
c.execute('''
CREATE TABLE IF NOT EXISTS usr (
    uid INTEGER PRIMARY KEY,
    name TEXT,
    checkedOutItems TEXT
)
''')

# Insert one user with hardcoded data
uid = 1  # Hardcoded user ID
name = 'John'  # Hardcoded name
checked_out_items = '1, 2, 3'  # Hardcoded checked out items

# Insert the user into the usr table
try:
    c.execute('''
        INSERT INTO usr (uid, name, checkedOutItems) 
        VALUES (?, ?, ?)
    ''', (uid, name, checked_out_items))
    conn.commit()
except sqlite3.IntegrityError as e:
    print(f"An error occurred: {e}")

# Fetch all data from the usr table
c.execute("SELECT * FROM usr")
rows = c.fetchall()

# Get column names
columns = [description[0] for description in c.description]

# Close the connection
conn.close()

# Construct a list of dictionaries with the row data
users_data = [dict(zip(columns, row)) for row in rows]

# Write the data to a JSON file
with open(json_file, 'w') as f:
    json.dump(users_data, f, indent=4)

# Provide the path to the JSON file for download
json_file
