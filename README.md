# supernova-hometest

## Python environment

Please use requirements.txt for pip and requirements.yml for conda

## Ingest and Transform

command: python ingest_and_transform.py -base_url- -table name- -host name- -database name- -username- -password-

example: python ingest_and_transform.py "https://dummyjson.com" "users" "db4free.net" "spnvtestdb01" "supernovaadmin01" "password"

## Google API

command: python google_sheet.py -host name- -database name- -username- -password- -credentials path- -output gsheet name-

example: python google_sheet.py "db4free.net" "spnvtestdb01" "supernovaadmin01" "password" "V:\VS Projects\Git\supernova-hometest\credentials\google_credentials.json" "supernova_home_test"

## Credentials

Your emails have been added to testing Google credentials: shay.chinn@supernovabrands.com, dinith@supernovabrands.com, sibasish.padhy@supernovabrands.com

## Data model

Model contains 3 layers: Bronze, Silver, Gold to process data. There are stored procedures and views to support the transforming process.