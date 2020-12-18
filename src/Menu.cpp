#include "Menu.h"

Menu::Menu(){
    choice = '1';
}

Menu::~Menu(){

}

void Menu::show(){
    cout << "1. Demarrer le service" << endl;
    cout << "2. Restarter le service(suprimme toutes les utilisateurs)" << endl;
    cout << "3. Stopper le service" << endl;
    cout << "4. Restarter le service(garde les utilisateurs déja connectés)" << endl;
    cout << "5. Quitter l'application" << endl;
    cout << "Entrer votre choix: ";
    cin >> choice;
}

void Menu::process(){
    switch (choice) {
        case '1':
            CaptivePortal::launch();
            break;

        case '2':
        CaptivePortal::reboot();
            break;

        case '3':
        CaptivePortal::stop();
            break;

        case '4':
        CaptivePortal::restart();
            break;
        
        default:
            cout << "Choix invalide!!" << endl;
            break;
    }
}

char Menu::getChoice(){
    return choice;
}

void Menu::setChoice(char _choice){
    choice = _choice;
}