// This programm will manage the firewall raised by the
// captive portal

// Author: RALAIKOA Falinirina Raphael Joseph
// Date: 14 Octobre 2020


#include <iostream>
#include <unistd.h>
#include "Menu.h"
#include "function.h"
#include "CaptivePortal.h"

using namespace std;
int main(int argc, char* argv[]){
    
    // Debut du programme
    // Verify if the programme is launched by root

    if (argc < 2){
        std::cerr << "Erreur argument" << std::endl;
        CaptivePortal::usage();
        return 1;
    }
    printSplashScreen();

    // Launching the main menu
    Menu menu = Menu();
    char choice = '1';
    while(1){
        sleep(2);
        // system("clear");
        // menu.show();
        // if(menu.getChoice() == '5'){
        //     CaptivePortal::stop();
        //     break;
        // }
        // menu.process();
    }

    // Fin du programme
    printEndProgrammText();
    return 0;
}
