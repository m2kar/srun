#!/bin/sh


chmod +x /etc/init.d/srun
rm -f /etc/rc.d/S96srun
ln -s /etc/init.d/srun /etc/rc.d/S96srun
echo "please input your username ppp-key wifi-ssid wifi-key:"
#read -p "start input:" user_id ppp_key wifi_ssid wifi_key
user_id=${1:-$(uci get srun.cmu_wifi.username)}
ppp_key=${2:-$(uci get srun.cmu_wifi.password)}
wifi_ssid=${3:-$(uci get wireless.@wifi-iface[0].ssid)}
wifi_ssid=${wifi_ssid:-CMU-WIFI}
wifi_key=${4:-$(uci get wireless.@wifi-iface[0].key)}
wifi_key=${wifi_key:-1234567890}
echo "user_id=$user_id ppp_key=$ppp_key "
echo "wifi_ssid=$wifi_ssid wifi_key=$wifi_key"
ppp_id=$(lua -e "print('\{SRUN2\}' .. string.gsub('$user_id','(.)',function(x) return string.char(string.byte(x)+4) end))")
echo "ppp_id=$ppp_id"
uci set srun.cmu_wifi.username=${user_id}
uci set srun.cmu_wifi.password=${ppp_key}
uci set dhcp.lan.ra_management=1
uci set network.lan.dns="180.76.76.76 119.29.29.29 218.30.118.6 114.114.114.114 8.8.8.8"
uci set network.wan.proto=pppoe
uci set network.wan.ipv6=auto
uci set network.wan.mtu=1250
uci set network.wan.username=${ppp_id}
uci set network.wan.password=${ppp_key}
uci set wireless.@wifi-iface[0].ssid=${wifi_ssid}
uci set wireless.@wifi-iface[0].encryption=psk2
uci set wireless.@wifi-iface[0].key=${wifi_key}
uci set wireless.@wifi-iface[0].wps_pushbutton=0
uci delete wireless.@wifi-iface[1]
uci delete wireless.@wifi-iface[1]

uci show network.wan
uci show network.lan.dns
uci show srun
uci show wireless

uci commit dhcp
uci commit network
uci commit wireless

uci show network.wan
uci show wireless

/etc/init.d/network restart
/etc/init.d/dnsmasq restart

#echo "stop srun"

#echo "start srun"
#/etc/init.d/srun start &

echo "success!"
