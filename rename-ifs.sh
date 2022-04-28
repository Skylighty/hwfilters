#!/bin/bash

# Network interfaces mapping:
# ens9f0 -> eth1
# ens9f1 -> eth2
# ens4f0 -> eth3
# ens4f1 -> eth4
# ens17f0np1 -> eth5
#ens 17f0np0 -> eth6

# Names mapping
declare -A ifnames
ifnames["ens9f0"]="eth0"
ifnames["ens9f1"]="eth1"
ifnames["ens4f0"]="eth2"
ifnames["ens4f1"]="eth3"
ifnames["ens17f1np1"]="eth4"
ifnames["ens17f0np0"]="eth5"

# ===== COLORS ======
RED='\033[0;31m'
GREEN='\033[0;32m'
YELL='\033[0;33m'
NC='\033[0m'
# ===================
DIR=/opt/mellanox/ethtool/sbin
if [[ -d "$DIR" ]]; then
    echo -e "${GREEN}OK${NC}. Mellanox OFED drivers found, proceeding."
    
    # Scan interfaces to file in format <interface-name>-<interface-MAC>
    # !!! TODO !!! Change set to math only 'ensXXXX' interfaces!
    ip -o link | awk '$2 != "lo:" {print $2, $(NF-2)}' | sed 's/: /-/g' > infs.txt
    
    # Create dictionary - inf:mac
    declare -A ifmap

    # Fill dictionary - dict[<interface-name>]=<interface-MAC>
    while IFS='-' read -r intfs mac; do
        ifmap[$intfs]=$mac
    done < infs.txt
else
    echo -e "${RED}ERROR - OFED drivers not found. Please install them!"
    exit 1
fi

cp /etc/netplan/00-installer-config.yaml /etc/netplan/bak.00
rm infs.txt
np=/etc/netplan/00-installer-config.yaml
for i in "${!ifmap[@]}"; do
    sed -i "/${i}:/a\      match:\n        macaddress: ${ifmap[${i}]}\n      set-name: ${ifnames[${i}]}" $np
done


echo -e "${GREEN}OK${NC}. Applying new netplan with changed ${YELL}network interface${NC} names"
echo -e "${RED}!!!${NC} Please wait patiently! ${RED}!!!${NC}\n"
netplan apply
echo -e "${GREEN}Changes applied!${NC}"