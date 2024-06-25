1.Launch db and pgadmin services by running the following command:

docker compose up -d


2.Copy files (pagila-schema.sql, pagila-insert-data.sql) of pagila database into our db service`s container by running the following commands:

docker cp ./pagila-schema.sql pgdev-project_db_1:/usr/src/pagila-schema.sql

docker cp ./pagila-insert-data.sql pgdev-project_db_1:/usr/src/pagila-insert-data.sql

Note: pgdev-project_db_1 – is the name of db service container


3.Create database by running docker compose exec

docker compose exec db psql -U postgres -c "CREATE DATABASE pagila;"


4.Sequentially run pagila-schema.sql and pagila-insert-data.sql scripts

docker compose exec db psql -U postgres -d pagila -f /usr/src/pagila-schema.sql

docker compose exec db psql -U postgres -d pagila -f /usr/src/pagila-insert-data.sql


5. Head to the http://localhost:8080/ in your browser and sign in using credentials from .env.list file.

6. Connect to the PostgreSQL server. Click on Add New Server. In the pop-up window, fill fields in General and Connection tabs and save changes.
