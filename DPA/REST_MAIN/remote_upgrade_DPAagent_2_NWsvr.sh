#!/bin/bash

/usr/bin/rsh RHEL58-NW8 -l root sh /root/DPA/AUTO_UPGRADE.sh && \
/usr/bin/rsh RHEL55-networker -l root sh /root/DPA/AUTO_UPGRADE.sh 
