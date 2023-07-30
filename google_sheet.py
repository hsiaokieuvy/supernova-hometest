from wrapper.mysql_wrapper import MySQLWrapper
from wrapper.google_wrapper import GoogleWrapper, GoogleSheetWrapper
from datetime import datetime
from logging import Logger
import argparse, logging, os
import pandas as pd

def argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("mysql_host", help="MySQL hostname", type=str)
    parser.add_argument("mysql_database", help="MySQL database name", type=str)
    parser.add_argument("mysql_user", help="MySQL username", type=str)
    parser.add_argument("mysql_password", help="MySQL password", type=str)
    parser.add_argument("google_credentials_path", help="Google credentials path", type=str)
    parser.add_argument("output_gsheet_name", help="Output Google spreadsheet name", type=str)
    return parser

def configure_logger() -> Logger:
    now = datetime.now()
    now_str = now.strftime("%d-%m-%Y_%H-%M-%S")
    logger = logging.getLogger("supernova")
    logger.setLevel(level=logging.INFO)
    handler = logging.FileHandler(filename=fr"./log/supernovatest_google_sheet_{now_str}.log", mode="w")
    formatter = logging.Formatter("%(asctime)s - [%(levelname)s] - %(message)s")
    handler.setFormatter(fmt=formatter)
    logger.addHandler(hdlr=handler)
    return logger

mysql_output = {
    "worksheet_name": ["Top 20 revenue by Products", "Top 20 Users with posts and comments", "Top 10 revenue by States"],
    "mysql_query": ["SELECT * FROM `test_revenue_by_product` LIMIT 20", "SELECT * FROM `test_highest_posts_with_comments` LIMIT 20", "SELECT * FROM `test_revenue_by_state` LIMIT 10"]
}

def main():
    # Parse arguments
    args = argument_parser().parse_args()

    # Create log folder
    dir_path = "./log"
    if os.path.exists(dir_path):
        pass
    else:
        os.makedirs(dir_path)

    # Configure logger
    logger = configure_logger()

    try:
        logger.info("Connecting to MySQL...")
        mysql_wrapper = MySQLWrapper(host=args.mysql_host, database=args.mysql_database, user=args.mysql_user, password=args.mysql_password)

        logger.info(f"Initializing Google credentials and Gsheet client...")
        google_wrapper = GoogleWrapper(credentials_path=args.google_credentials_path)
        gsheet_wrapper = GoogleSheetWrapper(creds=google_wrapper.creds)

        logger.info("Getting spreadsheet...")
        gsheet = gsheet_wrapper.get_or_create_spreadsheet(gsheet_name=args.output_gsheet_name)

        df = pd.DataFrame(data=mysql_output)
        for index, row in df.iterrows():
            worksheet_name = row["worksheet_name"]
            mysql_query = row["mysql_query"]
            logger.info(f"Running query number {index + 1}... Output worksheet name: {worksheet_name}")
            gsheet_df = gsheet_wrapper.write_to_worksheet(mysql_wrapper=mysql_wrapper, mysql_query=mysql_query, gsheet_id=gsheet.id, worksheet_name=worksheet_name)

            if worksheet_name == "Top 10 revenue by States":
                logger.info(f"Drawing bar chart from query number {index + 1}... Output worksheet name: {worksheet_name}")
                row_count = len(gsheet_df) + 1 #with header
                gsheet_wrapper.draw_bar_chart(df=gsheet_df, gsheet_id=gsheet.id, worksheet_name=worksheet_name, x_axis_name=gsheet_df.columns[0], y_axis_name=gsheet_df.columns[1], row_count=row_count)
            
            # print(f"Sample data for query number {index + 1}:")
            # print(gsheet_df.head(5))
    except Exception as err:
        print(err)
        mysql_wrapper.close_connection()         
        logger.error(err)
    finally:
        mysql_wrapper.close_connection()
        logger.info("Tasks completed.")

if __name__ == "__main__":
    main()