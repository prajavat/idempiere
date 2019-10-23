#!/bin/sh
#

cd $(dirname "${0}")
DESTINATION=$(pwd)

cp idempiere.ini idempiere.ini.sav

if [ -f server.xml.sav ];
then
   rm -f server.xml.sav
fi
if [ -f plugins/org.adempiere.tomcat.config_1.0.0/META-INF/tomcat/server.xml ]
then
   cp plugins/org.adempiere.tomcat.config_1.0.0/META-INF/tomcat/server.xml server.xml.sav
fi

VMOPTS="-Dorg.eclipse.ecf.provider.filetransfer.excludeContributors=org.eclipse.ecf.provider.filetransfer.httpclient4 -Djava.net.preferIPv4Stack=true"
java $VMOPTS -jar plugins/org.eclipse.equinox.launcher_1.*.jar -install director -configuration director/configuration -application org.eclipse.equinox.p2.director -consoleLog -profileProperties org.eclipse.update.install.features=true -destination $DESTINATION -repository $1 -u $2
java $VMOPTS -jar plugins/org.eclipse.equinox.launcher_1.*.jar -install director -configuration director/configuration -application org.eclipse.equinox.p2.director -consoleLog -profileProperties org.eclipse.update.install.features=true -destination $DESTINATION -repository $1 -i $2

 
cp idempiere.ini.sav idempiere.ini
if [ -f server.xml.sav ]
then
   cp server.xml.sav plugins/org.adempiere.tomcat.config_1.0.0/META-INF/tomcat/server.xml 
   rm -f server.xml.sav
fi

