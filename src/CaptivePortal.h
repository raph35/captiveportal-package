#ifndef CAPTIVE_PORTAL_H
#define CAPTIVE_PORTAL_H
#include <iostream>
#include <string>
#define PROG_NAME "captiveportal.sh"
#define PROG_PATH "/usr/local/lib/captiveportal"
#define IPTABLES_FILE_BACKUP "iptable.bak"

using namespace std;
class CaptivePortal{
public:
    CaptivePortal();
    ~CaptivePortal();

    static void launch();
    static void stop();
    static void restart();
    static void reboot();
    static void backupRules();
    static void restoreRules();
    static void end();
    static void usage();

private:
    static bool is_started;
    static string command;
    static string iptables_bak;
};
#endif
