#!/bin/bash
GLOBAL_ERR=0
echo 'Checking named.conf.local'
if named-checkconf -z /etc/bind/named.conf.local; then
	echo 'No errors'
else
	((GLOBAL_ERR++))
	echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	echo 'ERROR: There are errors in named.conf.local config'
	echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
fi

echo ''
echo 'Checking reverse lookup (zones/db.168.192.in-addr.arpa) for missing IPs from db.lan'

# check all IPs are registered in reverse lookup
ERRORS=0
declare -A checked_ips
dblan_lines="$(grep -P "192.168.1.[0-9]+" /etc/bind/zones/db.lan)"
while read -r line; do
	# Strip comments | Fixup the line so all fields are delimited by tabs
	clean_line="$(echo "$line" | sed -e 's/;.*$//' | tr -s '[:blank:]' '\t')"
	if [[ -z "$clean_line" ]]; then
		continue  # Empty line
	fi

	ip="$(echo "$clean_line" | grep -oP "192.168.1.[0-9]+")"
	if [[ -z "$ip" ]] ||  [[ -n "${checked_ips[\"$ip\"]}" ]]; then
		continue  # No IP or already checked; ignore
	fi
	checked_ips["$ip"]=1  # Flag as checked to prevent dupes
	rev="${ip#192.168.1.}.1"  # 192.168.1.8 -> 8.1
	if grep "^${rev}" "/etc/bind/zones/db.168.192.in-addr.arpa" >/dev/null; then
		echo "Exists $ip"
	else
		((GLOBAL_ERR++))
		((ERRORS++))
		echo "!!! Missing $ip in reverse lookup"
		echo "    ${line}"
	fi
done <<< "$dblan_lines"
[[ $ERRORS -eq 0 ]] && echo "No reverse lookup errors"

echo ''
if [[ $GLOBAL_ERR -eq 0 ]]; then
	echo "No errors!"
else
	echo "There were 1 or more errors"
	exit 1
fi

# Manual checks of zones.
# Leaving here because I discovered the -z option in named-checkconf
# sudo named-checkzone 168.192.in-addr.arpa /etc/bind/zones/db.192.168
# sudo named-checkzone unraid.lan /etc/bind/zones/db.unraid.lan

