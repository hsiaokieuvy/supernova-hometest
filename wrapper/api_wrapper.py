import requests as rq
import pandas as pd

class APIWrapper:
    def __init__(self, base_url: str) -> None:
        self.base_url = base_url
        self.json_data = None
    
    def get_json_table_from_url(self, table_name: str):
        url = self.base_url + f"/{table_name}"
        response = rq.get(url)
        raw_json_data = response.json()
        self.json_data = raw_json_data[table_name]
        return self.json_data
    
    def read_json(self, table_name: str):
        json_data = self.get_json_table_from_url(table_name=table_name)
        flattened_json_data = pd.json_normalize(json_data)
        return pd.DataFrame(flattened_json_data)
