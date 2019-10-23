# The purpose of this project is to make iDempiere on dockerize.

iDempiere and Open Source ERP are quite possibly the biggest discontinuous changes and enablers for producing business efficiency and insight.

# Setup iDempiere on docker
To install all components of iDempiere 5.1 on Docker Container, simply copy and paste hole iDempiere-Docker project in opt directory, Set All idempiere, Postgres & Solr relative properties in .env file. After about 8 minutes, iDempiere Container will appear on your machine.

# start Docker Container
docker-compose build
docker-compose up -d

# Stop Docker Container
docker-compose stop Container-name

# Restart Docker Container
docker-compose restart Container-name

# Check log of iDempiere 

# Create Core in Solr (Please Replace core name as per you want to create Ex:- DMS)
docker exec -it solr ./bin/solr create -c gettingstarted -n data_driven_schema_configs
docker exec -it solr ./bin/solr create -c DMS -n data_driven_schema_configs

# Create DMS_Content & DMS_Thumbnails folder in iDempiere container
docker exec -it idempiere mkdir /opt/idempiere-server/DMS_Content
docker exec -it idempiere mkdir /opt/idempiere-server/DMS_Thumbnails

# Install DMS in iDempiere container
docker exec -it idempiere sh dms-update.sh


# Setup Solr authentication
vi server/etc/jetty.xml

    <Call name="addBean">
      <Arg>
        <New class="org.eclipse.jetty.security.HashLoginService">
          <Set name="name">Test Realm</Set>
          <Set name="config"><SystemProperty name="jetty.home" default="."/>/etc/realm.properties</Set>
          <Set name="refreshInterval">0</Set>
        </New>
      </Arg>
    </Call>

vi server/solr-webapp/webapp/WEB-INF/web.xml

  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Solr authenticated application</web-resource-name>
      <url-pattern>/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
      <role-name>core1-role</role-name>
    </auth-constraint>
  </security-constraint>

  <login-config>
    <auth-method>BASIC</auth-method>
    <realm-name>Test Realm</realm-name>
  </login-config>

cd server/etc/
vi realm.properties
admin: admin,core1-role