#!/bin/bash

echo "IP address of Postgres"=$PGHOST
echo "Port no of postgres"=$PGPORT
echo "iDempiere DB name"=$IDEMPIERE_DB_NAME
echo "iDempiere Username"=$IDEMPIERE_DB_USER
echo "iDempiere Password"=$DBPASS
echo "Postgres Password"=$DBPASS_SU

PGPASS_FILE="/root/.pgpass"
if [ ! -f "$PGPASS_FILE" ]; then
    echo "*:*:*:$IDEMPIERE_DB_USER:$DBPASS">>/tmp/.pgpass
    echo "*:*:*:$IDEMPIERE_DB_USER_SU:$DBPASS_SU">>/tmp/.pgpass
    chmod 600 /tmp/.pgpass
    mv /tmp/.pgpass /root/
fi

if ! PGPASSWORD=$DBPASS psql -h $PGHOST -U $IDEMPIERE_DB_USER -d $IDEMPIERE_DB_NAME -c "\q" > /dev/null 2>&1 ; then
    echo "HERE: Initializing the database"
    cd $SCREPTS_PATH
    ./idempiere_initdb.sh root
    echo "HERE END: Initializing the database"

    echo "HERE: pgcrypto extension"
    psql -h $PGHOST -p $PGPORT -U $IDEMPIERE_DB_USER -d $IDEMPIERE_DB_NAME -c "CREATE EXTENSION pgcrypto"

    cd $SCREPTS_PATH
    ./idempiere_migration.sh
fi

file="$INSTALLPATH/utils/myEnvironment.sh"
if [ -f "$file" ]
then
cd $INSTALLPATH
sh console-setup-alt.sh <<!






Y
2
$PGHOST
$PGPORT
$IDEMPIERE_DB_NAME
$IDEMPIERE_DB_USER
$DBPASS
$DBPASS_SU
mail.dummy.com



Y
!
else
cd $INSTALLPATH
sh console-setup-alt.sh <<!







CA
US
0.0.0.0


Y
2
$PGHOST
$PGPORT
$IDEMPIERE_DB_NAME
$IDEMPIERE_DB_USER
$DBPASS
$DBPASS_SU
mail.dummy.com



Y
!
fi

exec "$@"