iDempiere on dockerize.
=========
iDempiere and Open Source ERP are quite possibly the biggest discontinuous changes and enablers for producing business efficiency and insight.

Requirements/Dependency
------------
idempiere repository only required docker on host machine.

  ## Install Docker.
  ```
  sudo apt-get update
  sudo apt-get install docker.io
  ```

  # Install Docker Compose.
  ```
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  ```

Start Docker Container
----------------------
```
docker-compose build
docker-compose up -d
```

Check log of iDempiere
----------------------
```
docker container logs --follow idempiere
```

Setup Solr authentication
-------------------------

```
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
```