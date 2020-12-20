#!/bin/sh

EXEC='captiveportal'

if [ ! -e $EXEC ]
then 
    echo "You need to compile the program first"
    echo "Type make to compile the program"
    exit 0
fi
installNode(){
    echo "Setting up the node Server ..."
	cp scripts/init.d/nodeServer /etc/init.d/nodeServer
	chmod +x /etc/init.d/nodeServer
	update-rc.d nodeServer defaults
}

install(){
    echo "Installing the program ..."
    cp $EXEC /usr/local/bin
	cp -ru lib /usr/local/lib/captiveportal
	cp -ru config /etc/captiveportal
	cp scripts/init.d/captiveportal /etc/init.d/captiveportal
	chmod +x /etc/init.d/captiveportal
	update-rc.d captiveportal defaults
    cp other/captiveportal.sudoer /etc/sudoers.d/captiveportal
}

reinstall(){
    echo "Resinstalling the program ..."
    cp -u $EXEC /usr/local/bin
	rm -rf /usr/local/lib/captiveportal /etc/captiveportal
	cp -r lib /usr/local/lib/captiveportal
	cp -r config /etc/captiveportal
	cp -u scripts/init.d/captiveportal /etc/init.d/captiveportal
	chmod +x /etc/init.d/captiveportal
	systemctl daemon-reload
}

case $1 in
    setupNode) installNode
    ;;
    install) install
    ;;
    reinstall) reinstall
    ;;
    *)
    ;;
esac