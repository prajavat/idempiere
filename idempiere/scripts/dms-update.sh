SCRIPTNAME=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPTNAME")

rm ../dms.p2.zip
rm -r ../dms

wget --auth-no-challenge --http-user=itadm --http-password=1180123da34645d29479bf52ca9669a070 -O ../dms.p2.zip http://jenkins.logilite.com/job/DMS-5_1/ws/buckminster.output/com.logilite.dms_1.0.1-eclipse.feature/site.p2/*zip*/site.p2.zip
# wget --auth-no-challenge --http-user=itadm --http-password=1180123da34645d29479bf52ca9669a070 -O ../dms.p2.zip  http://jenkins.logilite.com/job/DMS-5_1/ws/build/27/site.p2.zip

unzip ../dms.p2.zip -d ../dms

$SCRIPTPATH/update-customization.sh file:///opt/dms/site.p2 com.logilite.dms.feature.group
