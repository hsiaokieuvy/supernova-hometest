from wrapper.api_wrapper import APIWrapper
from wrapper.mysql_wrapper import MySQLWrapper
from datetime import datetime
import argparse, logging

def argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("base_url", help="API base URL", type=str)
    parser.add_argument("table_name", help="Target table name", type=str)
    parser.add_argument("mysql_host", help="MySQL hostname", type=str)
    parser.add_argument("mysql_database", help="MySQL database name", type=str)
    parser.add_argument("mysql_user", help="MySQL username", type=str)
    parser.add_argument("mysql_password", help="MySQL password", type=str)
    return parser

def main():
    # Parse arguments
    args = argument_parser().parse_args()

    # Configure logger
    now = datetime.now()
    now_str = now.strftime("%d-%m-%Y_%H-%M-%S")
    logger = logging.getLogger("supernova")
    logger.setLevel(level=logging.INFO)
    handler = logging.FileHandler(filename=fr"./log/supernovatest_{now_str}.log", mode="w")
    formatter = logging.Formatter("%(asctime)s - [%(levelname)s] - %(message)s")
    handler.setFormatter(fmt=formatter)
    logger.addHandler(hdlr=handler)

    try:
        logger.info(f"Fetching from table {args.table_name}...")
        api_wrapper = APIWrapper(base_url=args.base_url)
        df = api_wrapper.read_json(table_name=args.table_name)

        logger.info("Connecting to MySQL...")
        mysql_wrapper = MySQLWrapper(host=args.mysql_host, database=args.mysql_database, user=args.mysql_user, password=args.mysql_password)
        mysql_wrapper.process_table(table_name=args.table_name, df=df, logger=logger)
    except Exception as err:
        print(err)
        mysql_wrapper.close_connection()
        logger.error(err)
    finally:
        mysql_wrapper.close_connection()

if __name__ == "__main__":
    main()