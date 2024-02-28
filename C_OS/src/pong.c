#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>

/*declaration*/
 // -> signalhandler / routine d'interception
    /*globales*/
void SignalHandler();
__pid_t pParent;    //PID du prrocessus pere
int i;               //compteur d'iterations

///////////
//Routine d'interception
////////
void SignalHandler(int signal){ //num du signal recu
    if(signal == SIGUSR1){
        printf("PONG\n");
        kill(pParent, SIGUSR1);
    };
}

//prog principal

int main(void){
    struct sigaction    sa,        //definition de la fonction a appeler a la reception du signal
                        sa_old;     //sauvegarde de l'ancien comportement
    sigset_t            sa_mask;    //liste des signaux a masquer
    //initialisation
    memset(&sa, 0, sizeof(struct sigaction));   //RAZ de la structure
    sigemptyset(&sa_mask);                    //creation d'une liste de signaux vides
    sa.sa_sandler = SignalHandler;
    sa.sa_mask = sa_mask;
    sa.sa_flags = 0;

    /*installation de la routine d'interception*/
    if(sigactiont(SIGUSR1, &sa, &sa_old)<0){
        fprint(stderr, "ERREUR : appel a sigaction()\n");
        fpriint(stderr, "           code d'erreur = %d (%s)\n", errno, (char *)(strerror(errno)));
        return -errno;
    };
    //a ne fait rien a part attendre signal
    do{
        pause();
    } while(i<10);
    printf("FIN...\n");
    return 0;
}