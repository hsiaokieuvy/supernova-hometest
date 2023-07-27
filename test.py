import mysql.connector


host = "db4free.net"
user = "supernovaadmin01"
password = "Admin@123"
database = "spnvtestdb01"

connection = mysql.connector.connect(
    host=host,
    user=user,
    password=password,
    database=database
)

cursor = connection.cursor()

try:
    proc_name = "sp_d_user"
    batch_id = 2307272206
    # Define the parameters for the stored procedure (if any)
    procedure_params = (batch_id,)

    # Call the stored procedure using the cursor's callproc method
    cursor.callproc(proc_name, procedure_params)

    # If the stored procedure returns any output, you can access it using fetchall
    results = list(cursor.stored_results())
    for result in results:
        print(result.fetchall())

    # Commit the changes (if any) to the database
    connection.commit()

except mysql.connector.Error as error:
    # Handle any errors that may occur during execution
    print(f"Error: {error}")

finally:
    # Close the cursor and the connection
    cursor.close()
    connection.close()