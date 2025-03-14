wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xf sakila-db.tar.gz
[ "$UID" -eq 0 ] || sudo mariadb < ./sakila-db/sakila-schema.sql
[ "$UID" -eq 0 ] || sudo mariadb < ./sakila-db/sakila-data.sql
rm -rf sakila-db.tar.gz sakila-db
