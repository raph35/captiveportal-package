# function.sh		Script bash
#
# This file will contain all function that will be used
# by scripts for manipulating iptables chain and mysql datas

# Sourcing the configuration of the database
CONF_PATH=/etc/captiveportal

. ${CONF_PATH}/mysql.conf

MYSQL=/usr/bin/mysql
IPTABLES=/sbin/iptables

# Function which do query to the database set in the mysql.conf file
querySql(){
	# echo $1
	export MYSQL_PWD=$mysql_password
	$MYSQL -u $mysql_user $database_name -B -N -e "$1"
}

# Ping the ipaddress passed as parameter
pingUser(){
	ping -w 1 -c 1 $1 >/dev/null 2>&1
	return $?
}

# Delete user from mac or ip address in the databases
deleteUser(){
	# echo  "Deleting user with $1=$2"
	querySql "DELETE FROM connected WHERE connected.$1='$2'"
}

# Removing mac address from the mangle chain in the iptables
removeUser() {
	$IPTABLES -t mangle -D internet -m mac --mac-source $1 -j RETURN
}

# Getting users connected and updating firewall and database
updateConnected(){
	echo "Flushing all users not connected		[OK]"
	querySql 'SELECT pseudo, mac, ip FROM connected WHERE isConnected=1' | while read -r line
	do
		currentIp=`echo "$line" | cut -f3`
		mac_registred=`echo "$line" | cut -f2`

		# Ping the current ip and test the return value of the  script
		pingUser $currentIp
		if [ $? -eq 0 ];then
			# Verifing if mac address of this ip is equal to the mac address in the database
			mac_currentIp=`ip neigh | grep $currentIp | cut -f5 -d\ `
			if [ $mac_currentIp != $mac_registred ]; then
				echo "Mac obsolete: $mac_registred"
				deleteUser "mac" $mac_registred
				removeUser $mac_registred

			else
			echo "$currentIp at $mac_currentIp connected"
			fi

		else
			echo "$currentIp deconnected"
			deleteUser "ip" $currentIp
			removeUser $mac_registred
		fi
	done

	echo "Finishing flushing users			[OK]"
}


###
# param string list of all mac that need to be whitelisted
addWhitelist(){
	echo "removing $mac"
#	$IPATABLES -t mangle -I internet -m mac --mac-source $mac -j RETURN
}
