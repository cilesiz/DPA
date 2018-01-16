#!/bin/bash

sh POST_one_user_roles_apolloalert100_r.sh && sh POST_create_user_aa_ro.sh
sh POST_one_user_roles_apolloalert110_w.sh && sh POST_create_user_aa_rw.sh
sh POST_one_user_roles_apollouser100_r.sh && sh POST_create_user_au_ro.sh
sh POST_one_user_roles_apollouser110_w.sh && sh POST_create_user_au_rw.sh
sh POST_one_user_roles_scheduledreports100_r.sh && sh POST_create_user_ss_ro.sh
sh POST_one_user_roles_scheduledreports110_w.sh && sh POST_create_user_ss_rw.sh
