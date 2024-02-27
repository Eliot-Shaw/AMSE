/*=================================================*/
/* programme de simulation système 1er ordre       */
/*-------------------------------------------------*/
/* Jacques BOONAERT / cours SEMBA et AMSE          */
/*=================================================*/
#include <unistd.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h> /* ->INDISPENSABLE pour les types tempo. */
/*....................*/
/* variables globales */
/*....................*/
double K,
    tau,
    Te,
    T,
    z0,
    a0,
    yk,
    u0 = 1.0; /* ->secondes                            */
int GoOn = 1,
    simDuration; /* ->controle d'execution                */
/*...................*/
/* prototypes locaux */
/*...................*/
void usage(char *);         /* ->aide de ce programme                */
void cycl_alm_handler(int); /* ->gestionnaire pour l'alarme cyclique */
/*&&&&&&&&&&&&&&&&&&&&&&*/
/* aide de ce programme */
/*&&&&&&&&&&&&&&&&&&&&&&*/

// TODO
void usage(char *pgm_name)
{
    if (pgm_name == NULL)
    {
        exit(-1);
    };
    printf("%s <K> <tau> <Te> <T> <simDuration>\n", pgm_name);
    printf("calcule un système de 1er ordre en temps réel\n");
    printf("pendant une durée simDuration en secondes.\n");
}

double ynext(double yprec, double uk)
{
    return yprec * z0 + a0 * uk;
}

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/* gestionnaire de l'alarme cyclique */
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
void cycl_alm_handler(int signal)
{
    simDuration--;
    printf("temps restant: %02d\n", simDuration);
    yk = ynext(yk, u0);
    printf("y(k) = %lf\n", yk); 
    if (simDuration == 0)
    {
        printf("TERMINE !!! \n");
        GoOn = 0; /* declenche la sortie de programme */
    };
}

/*#####################*/
/* programme principal */
/*#####################*/
int main(int argc, char *argv[])
{
    struct sigaction sa,     /* ->configuration de la gestion de l'alarme */
        sa_old;              /* ->ancienne config de gestion d'alarme     */
    sigset_t blocked;        /* ->liste des signaux bloques               */
    struct itimerval period; /* ->periode de l'alarme cyclique            */
    /* verification des arguments */
    if (argc != 6)
    {
        usage(argv[0]);
        return (0);
    };
    /* recuperation des arguments */
    if ((sscanf(argv[1], "%lf", &K) == 0) ||
        (sscanf(argv[2], "%lf", &tau) == 0) ||
        (sscanf(argv[3], "%lf", &Te) == 0) ||
        (sscanf(argv[4], "%lf", &T) == 0) ||
        (sscanf(argv[5], "%d", &simDuration) == 0))
    {
        printf("ERREUR : probleme de format des arguments\n");
        printf("         passe en ligne de commande.\n");
        usage(argv[0]);
        return (0);
    };
    z0 = exp(-Te / tau);
    a0 = K * (1 - z0);
    yk = 0;
    /* initialisation */
    sigemptyset(&blocked);
    memset(&sa, 0, sizeof(sigaction)); /* ->precaution utile... */
    sa.sa_handler = cycl_alm_handler;
    sa.sa_flags = 0;
    sa.sa_mask = blocked;
    /* installation du gestionnaire de signal */
    sigaction(SIGALRM, &sa, NULL);
    /* initialisation de l'alarme  */
    printf("%lf",Te);
    period.it_interval.tv_sec = (int)Te;
    period.it_interval.tv_usec = (int)((Te- (int)Te))*1e6;
    period.it_value.tv_sec = (int)Te;
    period.it_value.tv_usec = (int)((Te- (int)Te))*1e6;
    /* demarrage de l'alarme */
    setitimer(ITIMER_REAL, &period, NULL);
    /* on ne fait desormais plus rien d'autre que */
    /* d'attendre les signaux                     */
    do
    {
        pause();
    } while (GoOn == 1);
    /* fini */
    printf("FIN DU DECOMPTE.\n");
    return (0); /* ->on n'arrive pas jusque la en pratique */
}
