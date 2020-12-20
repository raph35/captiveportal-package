# Captive portal
Copyright Misa L3 2022
By Raphaël - Toky - Ranto - Mickaëlla

## Software requirement

This program run on Ubuntu 18.04 and upper.

We need at least two network interfaces.

The software need also apache, mysql and nodejs in order to run the website.

## Installation
First of all, you have to check the configuration file.

Please change the value of password and user in the file `config/captiveportal.conf `

```bash
...
# Identification for the databases
mysql_user='admin'
mysql_password='******'
database_name='portailcaptif'
...
```

Then you can continue the installation.

To install the software, type the following command:

```bash
make && make install
```
Then to run the node server at every boot, you need to type this command:
```bash
make installNode
```

## Configuration files

The main configuration file is in ``` /etc/captiveportal ```

```bash
# This file is the main configuration file for the captive portal

# This is the network interface client side
eth_local='wlp3s0'

# This is the network interface internet side
eth_internet='enp2s0'

# This is the ipaddress of the local website
# (usually this ip address is the address in the client side interface
ip_addrWeb='10.42.0.1'

# Decomment the line bellow if you want to use different port for the web 
# http_port='81'
...
```

You must set the configuration for the database at this same file.

```bash
...
# Identification for the databases
mysql_user='admin'
mysql_password='******'
database_name='portailcaptif'
...
```

