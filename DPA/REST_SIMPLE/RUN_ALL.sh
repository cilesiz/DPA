#!/bin/bash

for t_i in `seq 10 10 600`
do
periksa=`ls -la /opt/emc/dpa/services/applications | grep -i deployed | wc -l`
if [ $periksa -lt 6 ]
then
echo "t_i = $t_i"
sleep 10
else
t_i=600
echo "STOP the seq 10 10 600"
echo "t_i = $t_i"

sh 1b_6a_get_lic_info.sh 
sh 1c_6b_post_base_newlic.sh 
sh 1e_6b_post_celerra_lic3.sh 
sh 2a_3_put_modify_ldap_autologon_grps_role_none.sh 
sh 2b_4_post_create_userldap1.sh 
sh 3_manual_create_agents_7_7.sh 
sh 4a_post_one_user_roles_No_Anything_User_no_rw.sh && sh 4b_post_create_user_user_norw_no_rw.sh
sh 4c_post_one_user_roles_AdministratorTWO.sh && sh 4d_post_create_user_admintwo.sh
sh 4e_post_one_user_roles_AdministratorTHREE.sh && sh 4f_post_create_user_adminthree.sh
sh 5_post_4_celerra_nodes.sh 
sh 6_rsh_autoupgrade_NWserver.sh
sh 7_PGADMIN.sh

exit
fi
done
