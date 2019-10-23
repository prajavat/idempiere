FROM openjdk:8

MAINTAINER Prashant Rajavat <prashant.rajavat1996@gmail.com>

ENV SCREPTS_PATH="/opt/scripts" \
    JENKINSURL="http://jenkins.logilite.com/" \
    JENKINSPROJECT="logiliteID_5_1" \
    JENKINS_BUILD_NUMBER="" \
    IDEMPIERE_VERSION="5.1" \
    JENKINS_AUTHCOMMAND="" \
    INSTALLPATH="/opt/idempiere-server" \
    TEMP_DIR="/tmp/idempiere-install-files" \
    IDEMPIERE_DB_NAME="${IDEMPIERE_DB_NAME:-idempiere}" \
    IDEMPIERE_DB_SCHEMA="adempiere" \
    IDEMPIERE_DB_USER="${IDEMPIERE_DB_USER:-adempiere}" \
    IDEMPIERE_DB_USER_SU="postgres" \
    PGHOST="${PGHOST:-postgres}" \
    PGPORT="${PGPORT:-5432}" \
    DBPASS_SU="${DBPASS_SU:-postgres}" \
    DBPASS="${DBPASS_SU:-idempiere}"

ENV IDEMPIERESOURCE_HOSTPATH="$JENKINSURL/job/$JENKINSPROJECT/ws/${JENKINS_BUILD_NUMBER}/buckminster.output/org.adempiere.server_"$IDEMPIERE_VERSION".0-eclipse.feature/" \
    IDEMPIERESOURCE_FILENAME="idempiereServer.gtk.linux.x86_64.zip" \
    IDEMPIERESOURCEPATHDETAIL="$JENKINSURL/job/$JENKINSPROJECT/ws/${JENKINS_BUILD_NUMBER}/changes"

RUN apt-get update && apt-get install -yq --no-install-recommends \
    unzip \
    expect \
    gzip \
    wget \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

ADD scripts /opt/scripts

RUN mkdir $TEMP_DIR && \
    chmod -R +x $SCREPTS_PATH/*.sh && \
    $SCREPTS_PATH/downloadtestzip.sh $IDEMPIERESOURCE_HOSTPATH $IDEMPIERESOURCE_FILENAME $TEMP_DIR "$JENKINS_AUTHCOMMAND" || exit 1    

RUN mkdir $INSTALLPATH && \
    chmod -R go+w $INSTALLPATH && \
    unzip $TEMP_DIR/$IDEMPIERESOURCE_FILENAME -d $TEMP_DIR && \
    cp -r $TEMP_DIR/idempiere.gtk.linux.x86_64/idempiere-server/* $INSTALLPATH && \
    rm -rf $TEMP_DIR

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod +x \
    $INSTALLPATH/*.sh \
    $INSTALLPATH/utils/*.sh \
    /entrypoint.sh

WORKDIR $INSTALLPATH
VOLUME /opt/idempiere-server
EXPOSE 8080 8443 12612

ENTRYPOINT ["/entrypoint.sh"]
CMD sh idempiere-server.sh