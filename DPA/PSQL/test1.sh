#!/bin/bash

usersql=apollosuperuser
pswdsql="3g1;23#6hFd 05(}c8/F5rB2lL1J79" 

# psql -h 10.64.213.74 -p 9003 --username "$usersql" -d postgres
echo "3g1;23#6hFd 05(}c8/F5rB2lL1J79" | psql -h 10.64.213.74 -p 9003 --username "$usersql" -d postgres
