#!/usr/bin/env bash
set -eu

function get_dns_info() {

        local rg=$1
        azure_ips=$(az network private-endpoint list --resource-group "$rg" | jq '.[].customDnsConfigs[] | .fqdn + " " + .ipAddresses[] ' | sort | tr -d '"')

        while read -r line; do
                first=$(echo "$line" | cut -d " " -f 1)
                second=$(echo "$line" | cut -d " " -f 2)
                check_dns "$first" "$second"
        done <<< "$azure_ips"
}

function check_dns() {
        local name=$1
        local azure_ip=$2
        snd_ip=$(curl -skL snd.cdc.gov/"$name" | jq '.ip_addresses[]' | tr -d '"' ; sleep 1)

        if [[ "$azure_ip" == "$snd_ip" ]]; then
                echo "FQDN $name in Azure ($azure_ip) matches snd ($snd_ip)"
        else
                echo "ERROR - FQDN $name in Azure DOES NOT match snd - Azure: $azure_ip SND: $snd_ip"
        fi
}


if [[ $#  == 0 ]]; then
        echo "Usage: checkdns.sh <<resource-group-name>>"
        exit 1
fi

get_dns_info "$1"
