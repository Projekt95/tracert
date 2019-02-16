#!/bin/bash
#https://github.com/Projekt95/tracert
#tracert is licensed under the GNU General Public License v3.0

tabs 8

if [[ -z "$1" || "$@" == *'-h'* ]]
    then echo -e "Usage:
 $(basename -- $0) [IP]
 $(basename -- $0) [DOMAIN]

Github:
https://Github.com/Projekt95/tracert"; exit

fi

##################################################################################
##################################################################################


timeout=2 #seconds


##################################################################################
##################################################################################


i=1
host=$1

while true; do 
	ping=$(ping -t $i -c 1 -W $timeout $host | grep -E "From|from")

	if [[ $(echo $ping | cut -d ' ' -f 1) == "64" ]]
		then
			#For last hop in route:
			if [[ $(echo $ping | cut -d ' ' -f 4 | tr -d '():' ) =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] 
				then echo -e "$i\t$(echo $ping | cut -d ' ' -f 4 | tr -d '():' )\t$host"
				else echo -e "$i\t$(echo $ping | cut -d ' ' -f 5 | tr -d '():' )\t$(echo $ping | cut -d ' ' -f 4)"
			fi
			exit 0
		
		else			
			#before last hop:
			if [[ $(echo $ping | cut -d ' ' -f 3 | tr -d '():') =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
				then echo -e "$i\t$(echo $ping | cut -d ' ' -f 3 | tr -d '():')\t$(echo $ping | cut -d ' ' -f 2)"
				else echo -ne "$i\t$(echo $ping | cut -d ' ' -f 2)\t"
					if [[ $(echo $ping | cut -d ' ' -f 2) =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
						then echo -e "$(host $(echo $ping | cut -d ' ' -f 2) | cut -d ' ' -f 5 | sed 's/\.$//g' | sed 's/3(NXDOMAIN)//g' | sed 's/2(SERVFAIL)//g')"
						else echo -e "*"
					fi
			fi
	fi
		
	((i++))
done 
