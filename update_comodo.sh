#!/bin/sh

echo [*] Pull Cert from git Repo
if [[ -z /opt/code/git/protected/certificates_demo.greenitglobe.com ]]; then
  echo [*_*] Can\'t find Certificate directory
  exit  
fi
cd /opt/code/git/protected/certificates_demo.greenitglobe.com
git pull

cd /opt/nginx/cfg
if [[ -z ssl-`timedatectl | grep 'Local\ time' | awk '{print $4}'` ]]; then
  mkdir ssl-`timedatectl | grep 'Local\ time' | awk '{print $4}'`
fi
if [[ -z ssl ]]; then
  echo [*_*] ssl dir not found, creating ssl ...
  mkdir ssl
  echo [*] Move old Certs to packup dir
  mv ssl/* ssl-`timedatectl | grep 'Local\ time' | awk '{print $4}'`
fi
echo [*] Move old Certs to packup dir
mv ssl/* ssl-`timedatectl | grep 'Local\ time' | awk '{print $4}'`

echo [*] Copy new Cert to ssl dir
cp /opt/code/git/protected/certificates_demo.greenitglobe.com/certnew/* /opt/nginx/cfg/ssl
cd /opt/nginx/cfg/ssl
cat COMODORSADomainValidationSecureServerCA.crt COMODORSAAddTrustCA.crt AddTrustExternalCARoot.crt >> demo.greenitglobe.com.crt

echo [*] Change nginx site configuration to use new cert
sed -i 's/ssl_certificate\ .*/ssl_certificate\ \/opt\/nginx\/cfg\/ssl\/demo\.greenitglobe\.com\.crt;/' /opt/nginx/cfg/sites-enabled/ovc
sed -i 's/ssl_certificate_key\ .*/ssl_certificate_key\ \/opt\/nginx\/cfg\/ssl\/demo\.greenitglobe\.com\.key;/' /opt/nginx/cfg/sites-enabled/ovc

echo [*] Restat nginx
ays restart -n nginx
