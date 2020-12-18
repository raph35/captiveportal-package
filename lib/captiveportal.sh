#!/bin/sh
#
# captiveportal			Startup script for the Captive Portal
#
#   description: Captive portal is a system which redirect every client 
#	to an authentication page before accessing internet
#   config: /etc/captiveportal/captiveportal.conf

RETVAL=0
SCRIPTNAME="${0##*/}"
IPTABLES=/sbin/iptables
IPTABLESSAVE=/sbin/iptables-save
IPTABLESRESTORE=/sbin/iptables-restore
CONF_PATH=/etc/captiveportal
LIB_PATH=/usr/local/lib/captiveportal
IPTABLES_PATH_BACKUP='/tmp/iptables.bak.tmp'

# Test if the user is root or not
# if [ $USER != 'root' ]; then	
# 	echo 'You must be root to launch the script'
# 	exit 1
# fi
# Function that display the usage of the script
usage() {
	echo "Usage: $SCRIPTNAME {start|stop|restart|reboot|flush}\n"
}

# Test if the number of argument is correct
if [ $# -ne 1 ]; then
	usage
	exit 1
fi


# Source variables from configuration file.
if [ ! -f ${CONF_PATH}/captiveportal.conf ]; then
	echo -n "Missing configuration file.
       	${CONF_PATH}/captiveportal.conf not found"
	exit 1
fi

. ${CONF_PATH}/captiveportal.conf

# echo "Port_http:`[ -z ${http_port} ]`Port_https:${https_port}"

HTTP_DEST=$ip_addrWeb
HTTPS_DEST=$ip_addrWeb

[ ! -z $http_port ] && HTTP_DEST=${HTTP_DEST}:${http_port}
[ ! -z $https_port ] && HTTPS_DEST=${HTTPS_DEST}:${https_port}

# Sourcing functions that will be used in the script
[ -r ${LIB_PATH}/function.sh ] || echo "File not found"

. ${LIB_PATH}/function.sh

# Functions
start() {
	echo "Starting captive portal..."

	echo "Saving iptables rules"
	$IPTABLESSAVE > $IPTABLES_PATH_BACKUP
	echo "Iptables rules saved"
	
	flush
	$IPTABLES -N internet -t mangle
	# echo "Chaine internet créer"

	# Default policy
	$IPTABLES -P FORWARD DROP

	#Envoi tous les traffics vers la chaine internet
	$IPTABLES -t mangle -A PREROUTING -j internet

	$IPTABLES -t mangle -A internet -i $eth_internet -j RETURN
	$IPTABLES -t mangle -A internet -i lo -j RETURN
	$IPTABLES -t mangle -A internet -j MARK --set-mark 99

	# Redirection des requettes http des utilisateurs non autorisée vers la page de login
	$IPTABLES -t nat -A PREROUTING -m mark --mark 99 -p tcp --dport 80 -j DNAT --to-destination $HTTP_DEST
	$IPTABLES -t nat -A PREROUTING -m mark --mark 99 -p tcp --dport 443 -j DNAT --to-destination $HTTPS_DEST

	# authorise les requettes dns servers
	$IPTABLES -I FORWARD -p udp --dport 53 -j ACCEPT
	$IPTABLES -A INPUT -p udp --dport 53 -j ACCEPT

	#Authorise la connection à l'internet
	echo "1" >/proc/sys/net/ipv4/ip_forward
	$IPTABLES -A FORWARD -i $eth_internet -o $eth_local -m state --state ESTABLISHED,RELATED -j ACCEPT
	$IPTABLES -A FORWARD -i $eth_local -o $eth_internet -j ACCEPT
	$IPTABLES -t nat -A POSTROUTING -o $eth_internet -j MASQUERADE

	# Rejette tous les paquets des utilisateurs non authentifiés
	$IPTABLES -t filter -I FORWARD -m mark --mark 99 -j DROP

	echo "Service captive portal launched		[OK]"
}

flush() {
	echo "Flushing previous iptables rules		[OK]"
	$IPTABLES -t mangle -F
	$IPTABLES -t mangle -X
	$IPTABLES -t nat -F
	$IPTABLES -F
	$IPTABLES -X
}

stop() {
	echo "Stopping captive portal..."
	flush
	$IPTABLESRESTORE $IPTABLES_PATH_BACKUP
	echo "Restoring rules"
	echo "Stopping service captive portal		[OK]"
}

addConnectedUser() {
	querySql 'SELECT pseudo, mac, ip FROM `connected` WHERE isConnected=1' | while read -r line
	do
		# echo $line
		mac=`echo "$line" | cut -f2`
		/sbin/iptables -t mangle -I internet -m mac --mac-source $mac -j RETURN
	done
}

removeAllConnected() {
	echo "Removing all connected user in the databases"
	querySql 'DELETE from connected WHERE 1'
}

setCronTab() {
	echo "Setting the crontab"
	echo "#This cron tab file is automatically generated by the program
#Do not edit it manually, instead edit the config file
${min} ${hour} * * * root ${LIB_PATH}/./captiveportal.sh rmDb" > /etc/cron.d/captiveportal
}

removeCronTab() {
	echo "Removing crontab"
	rm -f /etc/cron.d/captiveportal
}
# Main function
case "$1" in
	start)
		setCronTab
		start
		addConnectedUser
		;;
	stop)
		stop
		;;
	restart)
		echo "Restarting service..."
		stop
		start
		addConnectedUser
		;;
	reboot)
		echo "Rebooting service..."
		stop
		removeAllConnected
		start
		;;
	flush)
		flush
		;;
	rmDb)
		removeAllConnected
		;;
	exit)
		removeAllConnected
		removeCronTab
		;;
	*)
		usage
		RETVAL=1
esac

exit $RETVAL