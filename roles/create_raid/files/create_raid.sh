#!/bin/sh

megacli="/opt/MegaRAID/MegaCli/MegaCli64"

adp=$($megacli -adpallinfo -aall -NoLog  | awk -F# '/^Adapter/ {print "a"$2}')
en=$($megacli -EncInfo -$adp -NoLog | grep 'Device ID' | awk -F: '{print $2}' | sed -e 's/^ *//')
tag=$(dmidecode -t 1 | grep "Serial Number:" | awk '{print $3}')

#$megacli -CfgLdDel -LALL -Force -aALL > /dev/null 2>&1
#$megacli -CfgForeign -Clear -aALL > /dev/null 2>&1

system=$(dmidecode -t 1 | grep 'Product Name' | awk -F": " '{print $2}')

if [ "$system" = "PowerEdge R620" ] ; then
	$megacli -CfgLDAdd -R6[$en:2,$en:3,$en:4,$en:5,$en:6,$en:7,$en:8,$en:9] -$adp > /dev/null 2>&1
	sleep 3
	/sbin/parted -s -a optimal /dev/sdb mklabel gpt -- mkpart primary ext4 1 -1

elif [ "$system" = "PowerEdge R720xd" ] ; then 
	$megacli -CfgSpanAdd -R10 -Array0[$en:0,$en:1] -Array1[$en:2,$en:3] -Array2[$en:4,$en:5] -Array3[$en:6,$en:7] -$adp > /dev/null 2>&1
	sleep 3
	/sbin/parted -s -a optimal /dev/sdb mklabel gpt -- mkpart primary ext4 1 -1

fi

exit
