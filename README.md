# Captive portal
Copyright Misa L3 2022
By Raphaël - Toky - Ranto - Mickaëlla

## Software requirement

This program run on Ubuntu 18.04 and upper.

We need at least two network interfaces

## Installation
To install the software, type the following command
```bash
    make && make install
```

## Configuration file

The main configuration file is in ``` /etc/captiveportal ```

```bash
# This fill is the main configuration file for the captive portal

# This is the network interface client side
eth_local='wlp3s0'

# This is the network interface internet side
eth_internet='enp2s0'

# This is the ipaddress of the local website
# (usually this ip address is the address in the internet side interface
ip_addrWeb='10.42.0.1'

# Decomment the line bellow if you want to use different port for the web 
# http_port='81'
...
```

You can also set the configuration for the database at this configuration

```bash
...
# Identification for the databases
mysql_user='admin'
mysql_password='******'
database_name='portailcaptif'
...
```

