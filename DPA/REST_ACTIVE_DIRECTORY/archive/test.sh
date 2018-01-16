#!/bin/bash

HB_DPA=10.64.205.162

tukar1=`cat /tmp/tmp_dpa_lastmodified.txt | awk '{print $2}'`
sed -e 3_put_add_ad_svr_login_put_update.sh

sed -e "s/\(<ldapSettings\).*\(version\=\"1\">\)/\1<replacement string>\2/" 3_put_add_ad_svr_login_put_update.sh

sed -e "s/\(<ldapSettings\).*\(version\=\"1\">\)/\1 $tukar1 \2/" 3_put_add_ad_svr_login_put_update.sh
