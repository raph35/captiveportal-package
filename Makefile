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
	./scripts/install.sh install

reinstall:
	./scripts/install.sh reinstall

installNode:
	./scripts/install.sh setupNode

### Clean rules ###
clean:
	rm -f $(OBJ_DIR)/*.o
	rm $(EXEC)
