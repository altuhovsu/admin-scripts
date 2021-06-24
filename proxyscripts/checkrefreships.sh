#!/usr/bin/env bash
#set -e

zone="ZONENAME"
#zone=$1

iplist="${zone}ips.lst"
login="lum-customer-CUSTOMER-zone-$zone-ip-"
pass="PASSWORD"
serverport="zproxy.lum-superproxy.io:22225"
urltocheck="https://www.example.com"
authtoken="AUTHTOKEN"

ipstorefresh=""

echo "Updating iplists"
curl --fail --silent --show-error "https://brightdata.com/api/zone/route_ips?zone=$zone&expand=1" -H "Authorization: Bearer $authtoken" -o $iplist

echo "Checking file with IPs $iplist"

while read ipproxy; do
    #echo "curl --write-out '%{http_code}' --silent --output /dev/null --proxy $login$ipproxy:$pass@$serverport \"$urltocheck\""
    result=`curl --write-out '%{http_code}' --silent --output /dev/null --proxy $login$ipproxy:$pass@$serverport "$urltocheck"`
    echo $ipproxy' ---> '$result
    if [ $result != "200" ] && [ $result!="000" ]; then
        #echo $ipproxy' ---> '$result
        ipstorefresh+="\"$ipproxy\","
    fi
done < $iplist

if [ -n "${ipstorefresh}" ]; then
    echo "Refreshing IPs: $ipstorefresh"
    curl --fail --silent --show-error -X POST "https://brightdata.com/api/zone/ips/refresh" -H "Content-Type: application/json" -H "Authorization: Bearer $authtoken" -d "{\"zone\":\"${zone}\",\"ips\":[${ipstorefresh%?}]}"
fi
