from wrapper.mysql_wrapper import MySQLWrapper
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from typing import List
from gspread import Spreadsheet, Worksheet
import os, gspread
import gspread_dataframe as gd
import pandas as pd

class GoogleWrapper:
    def __init__(self, credentials_path: str, scopes: list = ["openid", "https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"], token_path: str = ".\credentials\google_token.json") -> None:
        self.creds = None
        
        if os.path.exists(token_path):
            self.creds = Credentials.from_authorized_user_file(filename=token_path, scopes=scopes)
        else:
            if not os.path.exists(".\credentials"):
                os.makedirs(".\credentials")

        # If there are no (valid) credentials available, let the user log in.
        if not self.creds or not self.creds.valid:
            if self.creds and self.creds.expired and self.creds.refresh_token:
                self.creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file(client_secrets_file=credentials_path, scopes=scopes)
                self.creds = flow.run_local_server(port=0)
            # Save the credentials for the next run
            with open(token_path, 'w') as token:
                token.write(self.creds.to_json())

class GoogleSheetWrapper:
    def __init__(self, creds: Credentials) -> None:
        self.client = gspread.authorize(credentials=creds)

    def get_spreadsheet_from_id(self, gsheet_id: str) -> Spreadsheet:
        gsheet = self.client.open_by_key(key=gsheet_id)
        return gsheet

    def get_or_create_spreadsheet(self, gsheet_name: str) -> Spreadsheet:
        try:
            gsheet = self.client.open(gsheet_name)
        except gspread.exceptions.SpreadsheetNotFound:
            gsheet = self.client.create(gsheet_name)
        return gsheet

    def get_or_create_worksheet(self, gsheet_id: str, worksheet_name: str) -> Worksheet:
        gsheet = self.client.open_by_key(gsheet_id)
        try:
            worksheet = gsheet.worksheet(worksheet_name)
        except gspread.exceptions.WorksheetNotFound:
            worksheet = gsheet.add_worksheet(title=worksheet_name, rows=100, cols=20)
        return worksheet
    
    def write_to_worksheet(self, mysql_wrapper: MySQLWrapper, mysql_query: str, gsheet_id: str, worksheet_name: str) -> pd.DataFrame:
        worksheet = self.get_or_create_worksheet(gsheet_id=gsheet_id, worksheet_name=worksheet_name)
        df = pd.read_sql(sql=mysql_query, con=mysql_wrapper.connection)
        gd.set_with_dataframe(worksheet=worksheet, dataframe=df)
        return df
    
    def draw_bar_chart(self, df: pd.DataFrame, gsheet_id: str, worksheet_name: str, x_axis_name: str, y_axis_name: str, row_count: int, column_index: int = 0) -> None:
        target_worksheet_name = f"{worksheet_name} Chart"
        worksheet = self.get_or_create_worksheet(gsheet_id=gsheet_id, worksheet_name=worksheet_name)
        target_worksheet = self.get_or_create_worksheet(gsheet_id=gsheet_id, worksheet_name=target_worksheet_name)
        request_body = {
            "requests": [
                {
                    "addChart": {
                        "chart": {
                            "spec": {
                                "title": worksheet_name,
                                "titleTextPosition": {
                                    "horizontalAlignment": "CENTER"
                                },
                                "basicChart": {
                                    "chartType": "BAR",
                                    "legendPosition": "BOTTOM_LEGEND",
                                    "axis": [
                                        {
                                            "position": "BOTTOM_AXIS",
                                            "title": y_axis_name
                                        },
                                        {
                                            "position": "LEFT_AXIS",
                                            "title": x_axis_name
                                        }
                                    ],
                                    "domains": [
                                        {
                                            "domain": {
                                                "sourceRange": {
                                                    "sources": [
                                                        {
                                                            "sheetId": worksheet.id,
                                                            "startRowIndex": 0,
                                                            "endRowIndex": row_count + 1,
                                                            "startColumnIndex": column_index ,
                                                            "endColumnIndex": column_index + 1
                                                        }
                                                    ]
                                                }
                                            }
                                        }
                                    ],
                                    "series": [
                                        {
                                            "series": {
                                                "sourceRange": {
                                                    "sources": [
                                                        {
                                                            "sheetId": worksheet.id,
                                                            "startRowIndex": 0,
                                                            "endRowIndex": row_count + 1,
                                                            "startColumnIndex": column_index + 1,
                                                            "endColumnIndex": column_index + 2
                                                        }
                                                    ]
                                                }
                                            },
                                            "targetAxis": "BOTTOM_AXIS"
                                        }
                                    ],
                                    "headerCount": 1
                                }
                            },
                            "position": {
                                "overlayPosition": {
                                    "anchorCell": {
                                        "sheetId": target_worksheet.id,
                                        "rowIndex": 0,
                                        "columnIndex": 0
                                    }
                                }
                            }
                        }
                    }
                }
            ]
        }

        gsheet = self.get_spreadsheet_from_id(gsheet_id=gsheet_id)
        response = gsheet.batch_update(body=request_body)

