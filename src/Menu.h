#ifndef MENU_H
#define MENU_H
#include <iostream>
#include "CaptivePortal.h"

using namespace std;

class CaptivePortal;

class Menu{
    public:
    // Contructor and desctructor
        Menu();
        ~Menu();

    // Loop and the textmenu
        void show();
        void loop();
        

    // Getters and setters 
        char getChoice();
        void setChoice(char choice);
        void process();

    private:
        char choice;
};


#endif