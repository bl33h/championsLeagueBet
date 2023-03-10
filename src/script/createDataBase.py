#/**
 #* *Copyright (C), 2023-2024, Sara Echeverria (bl33h)
    # *@author Sara Echeverria, Ricardo Mendez
    # *FileName: createDataBase
    # @version: I
    #- Creation: 20/02/2023
    #- Last modification: 28/02/2023


# Library import
import csv
import os
import psycopg2 # Database adapter for the Python programming language


# Function to rename the "cross" column, since PostgreSQL does not allow it
def rename_cross_column(column_names):
     return [col if col != "cross" else "crosses" for col in column_names] # The substitution takes places and the column is called "crosses"


# PostgreSQL database connection
conn = psycopg2.connect(
    host="localhost",
    database="championsleaguebet", # Database name (it must be created before executing the code)
    user="postgres", # psql user, it usually remains postgres
    password="passworD" # psql password
)
cur = conn.cursor()


# .csv files to read
csvFile = ["Match.csv", "Player.csv", "Player_Attributes.csv", "Team.csv", "Team_Attributes.csv", "Country.csv", "League.csv"]


for file in csvFile:
    # Name the table based on the name of the .csv file
    tableName = os.path.splitext(os.path.basename(file))[0]


    with open(file, encoding='utf-8') as f: # utf-8 allows the code to read special characters that are usually not compatible with Python
        reader = csv.reader(f)


        # Read the header of the .csv file
        header = next(reader)
        header = rename_cross_column(header)


        # Table creation
        cur.execute(f"CREATE TABLE IF NOT EXISTS {tableName} ({', '.join([f'{column} TEXT' for column in header])})")


        for row in reader:
            row = rename_cross_column(row)
           
            # Fill the empty cells with the word 'None' for PostgreSQL to identify it as NULL
            row = [None if cell == "" else cell for cell in row]
           
            # Delete every cell that contains .xml files
            row = [None if cell is None or ".xml" in cell else cell for cell in row]
           
            print(f"Before: {row}")


            # INSERT the row in the table
            cur.execute(f"INSERT INTO {tableName} ({', '.join(header)}) VALUES ({', '.join(['%s']*len(header))})", row)
            print(f"After empty cell fill: {row}")




# Finish the PostgreSQL database connection
conn.commit()
cur.close()
conn.close()


# Links consulted for the functions creation: https://www.w3schools.com/python/pandas/pandas_csv.asp, https://onlinecsvtools.com/delete-csv-columns,
# https://stackoverflow.com/questions/56379100/python-xml-and-csv-files-manipulation, https://towardsdatascience.com/extracting-information-from-xml-files-into-a-pandas-dataframe-11f32883ce45
