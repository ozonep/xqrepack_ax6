#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1
YOURSERVERIP=192.168.31.10

# cat >$FSDIR/etc/config/dhcp << EOF
# # uci set dhcp.@dnsmasq[0].dhcp_match=set:bios,60,PXEClient:Arch:00000
# # uci set dhcp.@dnsmasq[0].dhcp_boot=tag:bios,netboot.xyz.kpxe,,$YOURSERVERIP
# # uci set dhcp.@dnsmasq[0].dhcp_match=set:efi32,60,PXEClient:Arch:00002
# # uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi32,netboot.xyz.efi,,YOURSERVERIP
# # uci set dhcp.@dnsmasq[0].dhcp_match=set:efi32-1,60,PXEClient:Arch:00006
# # uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi32-1,netboot.xyz.efi,,YOURSERVERIP
# # uci set dhcp.@dnsmasq[0].dhcp_match=set:efi64,60,PXEClient:Arch:00007
# # uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi64,netboot.xyz.efi,,YOURSERVERIP
# # uci set dhcp.@dnsmasq[0].dhcp_match=set:efi64-1,60,PXEClient:Arch:00008
# # uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi64-1,netboot.xyz.efi,,YOURSERVERIP
# # uci set dhcp.@dnsmasq[0].dhcp_match=set:efi64-2,60,PXEClient:Arch:00009
# # uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi64-2,netboot.xyz.efi,,YOURSERVERIP
# # uci commit
# # /etc/init.d/dnsmasq restart

#         option dhcp_match 'set:bios,60,PXEClient:Arch:00000'
#         option dhcp_boot 'tag:bios,netboot.xyz.kpxe,,$YOURSERVERIP'
#         option dhcp_match 'set:efi32,60,PXEClient:Arch:00002'
#         option dhcp_boot 'tag:efi32,netboot.xyz.efi,,$YOURSERVERIP'
#         option dhcp_match 'set:efi32-1,60,PXEClient:Arch:00006'
#         option dhcp_boot 'tag:efi32-1,netboot.xyz.efi,,$YOURSERVERIP'
#         option dhcp_match 'set:efi64,60,PXEClient:Arch:00007'
#         option dhcp_boot 'tag:efi64,netboot.xyz.efi,,$YOURSERVERIP'
#         option dhcp_match 'set:efi64-1,60,PXEClient:Arch:00008'
#         option dhcp_boot 'tag:efi64-1,netboot.xyz.efi,,$YOURSERVERIP'
#         option dhcp_match 'set:efi64-2,60,PXEClient:Arch:00009'
#         option dhcp_boot 'tag:efi64-2,netboot.xyz.efi,,$YOURSERVERIP'
# EOF



# dhcp.@dnsmasq[0]=dnsmasq
# dhcp.@dnsmasq[0].domainneeded='1'
# dhcp.@dnsmasq[0].boguspriv='1'
# dhcp.@dnsmasq[0].filterwin2k='0'
# dhcp.@dnsmasq[0].localise_queries='1'
# dhcp.@dnsmasq[0].rebind_protection='0'
# dhcp.@dnsmasq[0].rebind_localhost='1'
# dhcp.@dnsmasq[0].local='/lan/'
# dhcp.@dnsmasq[0].expandhosts='1'
# dhcp.@dnsmasq[0].nonegcache='0'
# dhcp.@dnsmasq[0].authoritative='1'
# dhcp.@dnsmasq[0].allservers='1'
# dhcp.@dnsmasq[0].readethers='1'
# dhcp.@dnsmasq[0].leasefile='/tmp/dhcp.leases'
# dhcp.@dnsmasq[0].resolvfile='/tmp/resolv.conf.auto'
# dhcp.@dnsmasq[0].nonwildcard='1'
# dhcp.@dnsmasq[0].localservice='1'


# # OpenWRT
# uci set dhcp.@dnsmasq[0].dhcp_match=set:bios,60,PXEClient:Arch:00000
# uci set dhcp.@dnsmasq[0].dhcp_boot=tag:bios,netboot.xyz.kpxe,,192.168.31.10
# uci set dhcp.@dnsmasq[0].dhcp_match=set:efi32,60,PXEClient:Arch:00002
# uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi32,netboot.xyz.efi,,192.168.31.10
# uci set dhcp.@dnsmasq[0].dhcp_match=set:efi32-1,60,PXEClient:Arch:00006
# uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi32-1,netboot.xyz.efi,,192.168.31.10
# uci set dhcp.@dnsmasq[0].dhcp_match=set:efi64,60,PXEClient:Arch:00007
# uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi64,netboot.xyz.efi,,192.168.31.10
# uci set dhcp.@dnsmasq[0].dhcp_match=set:efi64-1,60,PXEClient:Arch:00008
# uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi64-1,netboot.xyz.efi,,192.168.31.10
# uci set dhcp.@dnsmasq[0].dhcp_match=set:efi64-2,60,PXEClient:Arch:00009
# uci set dhcp.@dnsmasq[0].dhcp_boot=tag:efi64-2,netboot.xyz.efi,,192.168.31.10
# uci commit
# /etc/init.d/dnsmasq restart


