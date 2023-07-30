import pandas as pd
import mysql.connector
from logging import Logger
from datetime import datetime
from sqlalchemy import create_engine, text
from urllib.parse import quote_plus

class MySQLWrapper:
    def __init__(self, host: str, user: str, password: str, database: str) -> None:
        self.connection_str = f"mysql+pymysql://{user}:{quote_plus(password)}@{host}:3306/{database}"
        self.sql_engine = create_engine(self.connection_str)
        self.connection = self.sql_engine.connect()
        self.mysql_con = mysql.connector.connect(host=host, user=user, password=password, database=database)

    # def init_connection(self, host: str, user: str, password: str, database: str) -> None:
    #     if not self.connection.closed:
    #         self.connection.close()
        
    #     self.connection_str = f"mysql+pymysql://{user}:{password}@{host}:3306/{database}"
    #     self.sql_engine = create_engine(self.connection_str, pool_recycle=3600)
    #     self.connection = self.sql_engine.connect()

    def close_connection(self) -> None:
        if not self.connection.closed:
            self.connection.close()
            self.mysql_con.close()
            self.sql_engine.dispose()
        else:
            pass

    def insert_from_dataframe(self, mysql_table_name: str, df: pd.DataFrame, logger: Logger) -> None:
        logger.info(f"Writing to {mysql_table_name}...")
        df.to_sql(name=mysql_table_name, con=self.connection, if_exists="append", index=False)

    def call_proc(self, mysql_proc_name: str, batch_id: int, logger: Logger) -> None:
        logger.info(f"Calling Stored Procedure {mysql_proc_name} with Batch ID {batch_id}...")
        
        cursor = self.mysql_con.cursor()
        proc_params = (batch_id,)
        try:
            cursor.callproc(mysql_proc_name, proc_params)
            results = list(cursor.stored_results())
            for result in results:
                print(result.fetchall())

            self.mysql_con.commit()
        except:
            cursor.close()
            raise Exception(f"An error occured when running {mysql_proc_name}.")
        finally:
            cursor.close()

    def process_users(self, df: pd.DataFrame, logger: Logger) -> None:
        now = datetime.now()
        now_str = now.strftime("%y%m%d%H%M")
        batch_id = int(now_str)
        table_name = "users"
        mysql_table_name = "bronze_d_user"
        mysql_proc_name = "sp_d_user"

        column_mapping = {
            "id": "userId",
            "hair.color": "hairColor",
            "hair.type": "hairType",
            "address.address": "address",
            "address.city": "city",
            "address.coordinates.lat": "coordinatesLat",
            "address.coordinates.lng": "coordinatesLng", 
            "address.postalCode": "postalCode",
            "address.state": "state",
            "bank.cardExpire": "bankCardExpire",
            "bank.cardNumber": "bankCardNumber",
            "bank.cardType": "bankCardType",
            "bank.currency": "bankCurrency",
            "bank.iban": "bankIban",
            "company.address.address": "companyAddress",
            "company.address.city": "companyCity",
            "company.address.coordinates.lat": "companyCoordinatesLat",
            "company.address.coordinates.lng": "companyCoordinatesLng",
            "company.address.postalCode": "companyPostalCode",
            "company.address.state": "companyState",
            "company.department": "companyDepartment",
            "company.name": "companyName",
            "company.title":"companyTitle" 
        }

        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id}...")
        result_df = df.copy()
        if result_df.shape[1] > 1:
            result_df.rename(columns=column_mapping, inplace=True)
        result_df["batchId"] = batch_id

        self.insert_from_dataframe(mysql_table_name=mysql_table_name, df=result_df, logger=logger)
        self.call_proc(mysql_proc_name=mysql_proc_name, batch_id=batch_id, logger=logger)
        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id} completed.")

    
    def process_products(self, df: pd.DataFrame, logger: Logger) -> None:
        now = datetime.now()
        now_str = now.strftime("%y%m%d%H%M")
        batch_id = int(now_str)
        table_name = "products"
        mysql_table_name = "bronze_d_product"
        mysql_proc_name = "sp_d_product"

        column_mapping = {
            "id": "productId"
        }

        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id}...")
        result_df = df.copy()
        result_df.rename(columns=column_mapping, inplace=True)
        result_df["batchId"] = batch_id
        if "images" in result_df.columns:
            result_df["images"] = result_df["images"].apply(lambda x: ", ".join(x))

        self.insert_from_dataframe(mysql_table_name=mysql_table_name, df=result_df, logger=logger)
        self.call_proc(mysql_proc_name=mysql_proc_name, batch_id=batch_id, logger=logger)
        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id} completed.")

    def process_carts(self, df: pd.DataFrame, logger: Logger) -> None:
        now = datetime.now()
        now_str = now.strftime("%y%m%d%H%M")
        batch_id = int(now_str)
        table_name = "carts"
        mysql_table_name = "bronze_f_cart"
        mysql_proc_name = "sp_f_cart"

        columns = ["cartId", "userId", "productId", "title", "price", "quantity", "discountPercentage"]
        column_mapping = {
            "id": "cartId",
        }
        product_columns = ["id", "title", "price", "discountPercentage"]
        product_column_mapping = {
            "product.id": "id",
            "product.title": "title",
            "product.price": "price",
            "product.quantity": "quantity",
            "product.discountPercentage": "discountPercentage"
        }

        temp_df = pd.json_normalize(data=df.to_dict(orient="records"), record_path="products", meta=["id", "userId"], record_prefix="product.").rename(columns=column_mapping)
        temp_df.rename(columns=product_column_mapping, inplace=True)
        
        logger.info(f"Processing sub table [products] in table [{table_name}] with Batch ID {batch_id}...")
        # Process products data
        # ------------------------------------------------------------------------------------------------
        product_df = temp_df[product_columns]
        product_df = product_df.drop_duplicates()
        self.process_products(df=product_df, logger=logger)
        # ------------------------------------------------------------------------------------------------
        
        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id}...")
        temp_df.rename(columns={"id": "productId"}, inplace=True)
        result_df = temp_df[columns]
        result_df["batchId"] = batch_id

        self.insert_from_dataframe(mysql_table_name=mysql_table_name, df=result_df, logger=logger)
        self.call_proc(mysql_proc_name=mysql_proc_name, batch_id=batch_id, logger=logger)
        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id} completed.")

    def process_posts(self, df: pd.DataFrame, logger: Logger) -> None:
        now = datetime.now()
        now_str = now.strftime("%y%m%d%H%M")
        batch_id = int(now_str)
        table_name = "posts"
        mysql_table_name = "bronze_f_post"
        mysql_proc_name = "sp_f_post"

        column_mapping = {
            "id": "postId"
        }

        logger.info(f"Processing sub table [users] in table [{table_name}] with Batch ID {batch_id}...")
        # Process users data
        # ------------------------------------------------------------------------------------------------
        user_df = df[["userId"]]
        user_df = user_df.drop_duplicates()
        self.process_users(df=user_df, logger=logger)
        # ------------------------------------------------------------------------------------------------

        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id}...")
        result_df = df.copy()
        result_df.rename(columns=column_mapping, inplace=True)
        result_df["batchId"] = batch_id
        if "tags" in result_df.columns:
            result_df["tags"] = result_df["tags"].apply(lambda x: ", ".join(x))

        self.insert_from_dataframe(mysql_table_name=mysql_table_name, df=result_df, logger=logger)
        self.call_proc(mysql_proc_name=mysql_proc_name, batch_id=batch_id, logger=logger)
        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id} completed.")

    def process_comments(self, df: pd.DataFrame, logger: Logger) -> None:
        now = datetime.now()
        now_str = now.strftime("%y%m%d%H%M")
        batch_id = int(now_str)
        table_name = "comments"
        mysql_table_name = "bronze_f_comment"
        mysql_proc_name = "sp_f_comment"


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

        logger.info(f"Processing sub table [users] in table [{table_name}] with Batch ID {batch_id}...")
        # Process users data
        # ------------------------------------------------------------------------------------------------
        user_df = temp_df[user_columns]
        user_df = user_df.drop_duplicates()
        self.process_users(df=user_df, logger=logger)
        # ------------------------------------------------------------------------------------------------

        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id}...")
        result_df = temp_df[columns]
        result_df["batchId"] = batch_id

        self.insert_from_dataframe(mysql_table_name=mysql_table_name, df=result_df, logger=logger)
        self.call_proc(mysql_proc_name=mysql_proc_name, batch_id=batch_id, logger=logger)
        logger.info(f"Processing table [{table_name}] with Batch ID {batch_id} completed.")

    def process_table(self, table_name: str, df: pd.DataFrame, logger: Logger) -> None:
        match table_name:
            case "users":
                return self.process_users(df=df, logger=logger)
            case "products":
                return self.process_products(df=df, logger=logger)
            case "carts":
                return self.process_carts(df=df, logger=logger)
            case "posts":
                return self.process_posts(df=df, logger=logger)
            case "comments":
                return self.process_comments(df=df, logger=logger)
            case default:
                raise Exception("No table found.")
            

        