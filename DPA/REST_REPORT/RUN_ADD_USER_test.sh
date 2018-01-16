#!/bin/bash

pwd1=/root/rosli/DPA/REST_REPORT

cd "$pwd1"/TEST_USERS

sh POST_one_user_roles_activereport100_r.sh
sh POST_one_user_roles_activereport110_w.sh
sh POST_one_user_roles_reporttemplate100_r.sh
sh POST_one_user_roles_reporttemplate110_w.sh
sh POST_one_user_roles_scheduledreports100_r.sh
sh POST_one_user_roles_scheduledreports110_w.sh
sh POST_one_user_roles_systemsetting100_r.sh
sh POST_one_user_roles_systemsetting110_w.sh

sh POST_create_user_ar_ro.sh
sh POST_create_user_ar_rw.sh
sh POST_create_user_rt_ro.sh
sh POST_create_user_rt_rw.sh
sh POST_create_user_ss_ro.sh
sh POST_create_user_ss_rw2.sh
sh POST_create_user_ss_rw3.sh
sh POST_create_user_ss_rw4.sh
sh POST_create_user_ss_rw.sh
sh POST_create_user_st_ro.sh
sh POST_create_user_st_rw.sh

sh POST_one_user_roles_TEST123.sh
sh POST_one_user_roles_TEST345.sh

sh POST_create_user_test234.sh
sh POST_create_user_test456.sh
