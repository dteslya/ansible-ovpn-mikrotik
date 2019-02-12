# feb/12/2019 21:54:58 by RouterOS 6.43.11
# software id = 1N2K-VCKS
#
# model = 951G-2HnD
# serial number = 642E07B36E70
/interface lte
set [ find ] mac-address=0C:5B:8F:27:9A:64 name=lte1
/interface bridge
add admin-mac=64:D1:54:33:50:77 auto-mac=no comment=defconf name=bridge
add name=bridge1 protocol-mode=none
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-XX distance=indoors frequency=auto mode=ap-bridge ssid=MikroTik-33507B wireless-protocol=802.11
/interface ethernet
set [ find default-name=ether5 ] mac-address=98:E7:F4:E9:3E:0E
/interface ovpn-client
add certificate=mikrotik.crt_0 cipher=aes128 connect-to=188.72.78.77 mac-address=02:71:06:D8:66:27 name=ovpn-out1 port=443 user=mikrotik
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=default-dhcp disabled=no interface=bridge name=defconf
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge1 comment=defconf interface=ether5
add bridge=bridge comment=defconf interface=wlan1
add bridge=bridge comment=defconf interface=*2
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
/ip address
add address=192.168.88.1/24 comment=defconf interface=bridge network=192.168.88.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid disabled=no interface=ether1
add add-default-route=no dhcp-options=hostname,clientid disabled=no interface=bridge1
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 name=router.lan
/ip firewall filter
add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input in-interface=ovpn-out1
add action=drop chain=input comment="defconf: drop all not coming from LAN" in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related
add action=accept chain=forward comment="defconf: accept established,related, untracked" connection-state=established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
add action=drop chain=forward comment="defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN
add action=masquerade chain=srcnat out-interface=bridge1
/ip route
add distance=1 dst-address=172.16.0.0/12 gateway=172.29.101.1
add distance=1 dst-address=192.168.69.0/24 gateway=192.168.70.5
/system clock
set time-zone-name=Asia/Krasnoyarsk
/system ntp client
set enabled=yes server-dns-names=time.google.com,0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN