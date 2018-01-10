#!/bin/sh

SERVERNAME=<myaccount>.postgres.database.azure.com
USER=<myuser>@<myaccount>
PORT=5432
DBNAME=postgres

psql --host=$SERVERNAME --port=$PORT --username=$USER --dbname=$DBNAME
