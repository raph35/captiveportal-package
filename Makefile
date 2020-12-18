#############################################
#			raph35							#
#		This file is a generic makefile		#
#	which can compile any project in C++ 	#
#	created by Raphael, Copyright 2020		#
#############################################

### Configuration of compilator ###
CC=g++
CFLAGS=-Wall
LDFLAGS=

### Configuration of output file ###
EXEC_NAME=captiveportal
EXEC_DIR=.
EXEC=$(EXEC_DIR)/$(EXEC_NAME)
SRC_DIR=src
INC_DIR=src
OBJ_DIR=src
SRC=$(wildcard $(SRC_DIR)/*.cpp)
_OBJ=$(SRC:.cpp=.o)
OBJ = $(subst $(SRC_DIR)/,$(OBJ_DIR)/,$(_OBJ))

###	The main rule
all: $(EXEC)

###	Compilation of the main file(linking) ###
$(EXEC): $(OBJ)
	@echo 'Compiling program'
	$(CC) -o $@ $^ $(LDFLAGS)

###	Creation of objects of all sources files ###
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo 'Créating objects files'
	$(CC) -o $@ -c $< $(LDFLAGS)

### Install rules ###
install:
	@echo 'Copying files...'
	cp $(EXEC) /usr/local/bin
	cp -r lib /usr/local/lib/captiveportal
	cp -r config /etc/captiveportal
	cp other/service /etc/init.d/captiveportal
	chmod +x /etc/init.d/captiveportal
	update-rc.d captiveportal defaults
	@echo 'Installation finished'

reinstall:
	cp -u $(EXEC) /usr/local/bin
	rm -rf /usr/local/lib/captiveportal /etc/captiveportal
	cp -r lib /usr/local/lib/captiveportal
	cp -r config /etc/captiveportal
	cp -u other/service /etc/init.d/captiveportal
	chmod +x /etc/init.d/captiveportal
	systemctl daemon-reload


### Clean rules ###
clean:
	rm -f $(OBJ_DIR)/*.o
	rm $(EXEC)
