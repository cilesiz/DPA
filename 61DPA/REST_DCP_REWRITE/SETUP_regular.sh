#!/bin/bash

DPAserver="$1"

if [ -n "$DPAserver" ]; then
/root/rosli/61DPA/REST_LIC/POST_lic_all_argv.sh "$DPAserver"
/root/rosli/61DPA/REST_CREDENTIAL/POST_credential_argv.sh "$DPAserver" Standard Administratorserverg0d Administrator serverg0d "Common DPA Windows Administrator"
/root/rosli/61DPA/REST_CREDENTIAL/POST_credential_argv.sh "$DPAserver" Standard rootserverg0d root serverg0d "Common DPA Linux/Unix root"
/root/rosli/61DPA/REST_CREDENTIAL/POST_credential_argv.sh "$DPAserver" Standard rootrisckey root risckey "Common HB Linux/Unix root"
/root/rosli/61DPA/REST_CREDENTIAL/POST_credential_argv.sh "$DPAserver" Standard rootH0meBase root H0meBase "Another Common HB Linux/Unix root"
/root/rosli/61DPA/REST_CREDENTIAL/POST_credential_argv.sh "$DPAserver" Standard WYSDMtalibr "WYSDM\talibr" irix293 "Rosli WYSDM account"
/root/rosli/61DPA/REST_CREDENTIAL/POST_credential_argv.sh "$DPAserver" Standard istechH0meBase istech H0meBase "HomeBase vCenter administrator"
/root/rosli/61DPA/REST_CREDENTIAL/POST_credential_argv.sh "$DPAserver" Unix UNIXrootserverg0d root serverg0d "Common DPA Linux/Unix root"
/root/rosli/61DPA/REST_CREDENTIAL/POST_credential_argv.sh "$DPAserver" Windows winWYSDMtalibr talibr irix293 "Rosli WYSDM account" WYSDM

else
echo; echo "No DPA server given"
echo; echo "./SETUP_regular.sh or sh SETUP_regular.sh <DPA server>"
echo; echo
fi
