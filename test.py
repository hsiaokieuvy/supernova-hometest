from wrapper.api_wrapper import APIWrapper
from wrapper.mysql_wrapper import MySQLWrapper
from datetime import datetime
import os
import pandas as pd
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
import gspread
import gspread_dataframe as gd
from gspread import Spreadsheet


host = "db4free.net"
user = "supernovaadmin01"
password = "Admin@123"
database = "spnvtestdb01"
base_url = "https://dummyjson.com"
table_name = "comments"
google_credentials_path = "V:\VS Projects\Git\supernova-hometest\credentials\google_credentials.json"
google_token_path = "V:\VS Projects\Git\supernova-hometest\credentials\google_token.json"
scopes = ["openid", "https://www.googleapis.com/auth/spreadsheets"]
sheet_id = "1TnarlrMp77lSIl06dibz7b03LJAzzG-EFwEMGZTotT4"

def create_or_get_worksheet(gsheet: Spreadsheet, worksheet_name):
    # Check if the worksheet exists
    try:
        worksheet = gsheet.worksheet(worksheet_name)
    except gspread.exceptions.WorksheetNotFound:
        # If the worksheet doesn't exist, create a new one
        worksheet = gsheet.add_worksheet(title=worksheet_name, rows=100, cols=20)

    return worksheet



try:
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(google_token_path):
        creds = Credentials.from_authorized_user_file(filename=google_token_path, scopes=scopes)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(client_secrets_file=google_credentials_path, scopes=scopes)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open(google_token_path, 'w') as token:
            token.write(creds.to_json())

    client = gspread.authorize(credentials=creds)
    # gsheet_list = client.openall()
    # for gsheet in gsheet_list:
    #     print(gsheet.title)

    gsheet = client.open_by_key(sheet_id)

    new_tab_name = "Top 20 Product and Revenue"
    worksheet = create_or_get_worksheet(gsheet, new_tab_name)

    mysql_wrapper = MySQLWrapper(host=host, user=user, password=password, database=database)
    mysql_query = "SELECT * FROM `test_revenue_by_product`"

    df = pd.read_sql(sql=mysql_query, con=mysql_wrapper.connection)
    print(df)

    gd.set_with_dataframe(worksheet, df)

except Exception as error:
    # Handle any errors that may occur during execution
    print(f"Error: {error}")
finally:
    # Close the cursor and the connection
    # mysql_wrapper.close_connection()
    pass