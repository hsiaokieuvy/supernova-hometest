from wrapper.api_wrapper import APIWrapper
from wrapper.mysql_wrapper import MySQLWrapper
from datetime import datetime
import os
import pandas as pd


host = "db4free.net"
user = "supernovaadmin01"
password = "Admin@123"
database = "spnvtestdb01"
base_url = "https://dummyjson.com"
table_name = "comments"

# connection = mysql.connector.connect(
#     host=host,
#     user=user,
#     password=password,
#     database=database
# )

try:
    api_wrapper = APIWrapper(base_url=base_url)
    df = api_wrapper.read_json(table_name=table_name)

    columns = ["commentId", "postId", "userId", "body"]
    column_mapping = {
        "id": "commentId"
    }
    user_columns = ["userId", "username"]
    user_column_mapping = {
        "user.id": "userId",
        "user.username": "username"
    }

    temp_df = df.rename(columns=column_mapping).rename(columns=user_column_mapping)
    # Process users data
    # ------------------------------------------------------------------------------------------------
    user_df = temp_df[user_columns]
    user_df = user_df.drop_duplicates()
    print(user_df)
    # ------------------------------------------------------------------------------------------------
    result_df = temp_df[columns]
    print(result_df)
except Exception as error:
    # Handle any errors that may occur during execution
    print(f"Error: {error}")
finally:
    # Close the cursor and the connection
    pass