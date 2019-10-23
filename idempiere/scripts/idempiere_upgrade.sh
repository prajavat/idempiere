#!/bin/bash

SERVER_DIR=$INSTALLPATH
TEMP_DIR=/tmp
ID_DB_NAME=$IDEMPIERE_DB_NAME
PG_CONNECT="NONE"
MIGRATION_DIR=$TEMP_DIR"/chuboe_temp/migration"
JENKINS_BUILD_NUMBER=""
MIGRATION_DOWNLOAD="$JENKINS_AUTHCOMMAND $JENKINSURL/job/$JENKINSPROJECT/ws/${JENKINS_BUILD_NUMBER}/migration/*zip*/migration.zip"
P2="$JENKINSURL/job/$JENKINSPROJECT/ws/${JENKINS_BUILD_NUMBER}/buckminster.output/org.adempiere.server_"$IDEMPIERE_VERSION".0-eclipse.feature/site.p2/*zip*/site.p2.zip"

if [[ $PG_CONNECT == "NONE" ]]
then
	PG_CONNECT="-h $PGHOST"
fi

IDEMPIERESOURCEPATHDETAIL="$JENKINSURL/job/$JENKINSPROJECT/ws/${JENKINS_BUILD_NUMBER}/changes"

# show variables to the user (debug)
echo "if you want to find for echoed values, search for HERE:"
echo "HERE: print variables"
echo "SERVER_DIR="$SERVER_DIR
echo "P2="$P2
echo "ID_DB_NAME="$IDEMPIERE_DB_NAME
echo "PG_CONNECT="$PG_CONNECT
echo "MIGRATION_DIR="$MIGRATION_DIR
echo "MIGRATION_DOWNLOAD="$MIGRATION_DOWNLOAD
echo "JENKINSPROJECT="$JENKINSPROJECT
echo "IDEMPIERE_VERSION="$IDEMPIERE_VERSION
echo "TEMP_DIR="$TEMP_DIR


mkdir $TEMP_DIR/chuboe_temp
mkdir $MIGRATION_DIR

cd $TEMP_DIR/chuboe_temp/
MIGRATION_DOWNLOAD=$(echo $MIGRATION_DOWNLOAD | sed 's|//*|/|g' | sed 's|:/|://|g')
echo "MIGRATION_DOWNLOAD="$MIGRATION_DOWNLOAD

wget $JENKINS_AUTHCOMMAND $MIGRATION_DOWNLOAD
unzip migration.zip

P2_DOWNLOAD=$(echo $P2 | sed 's|//*|/|g' | sed 's|:/|://|g')
echo "P2_DOWNLOAD="$P2_DOWNLOAD

cd $TEMP_DIR/chuboe_temp/
wget $JENKINS_AUTHCOMMAND $P2_DOWNLOAD
unzip site.p2.zip

# update iDempiere binaries
cd $SERVER_DIR
./update.sh file://$TEMP_DIR/chuboe_temp/site.p2/

cd $SCREPTS_PATH
./syncApplied.sh $MIGRATION_DIR

rm -rf $MIGRATION_DIR