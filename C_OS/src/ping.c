/*===========================================*/
/* ce programme lance un processus fils et   */
/* dialogue avec lui au travers de l'echange */
/* du signal SIGUSR1                         */
/*===========================================*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <signal.h>

#include <sys/types.h>
#include <sys/wait.h>

#define PATH2_EXECUTABLE     "../bin/pong"      /* ->image executable a demarrer      */
#define MAX_ITER              10                /* ->nombre d'iterations de l'echange */
#define SLEEP_TIME            500000            /* ->duree d'attente                  */
/*.........*/
/* globale */
/*.........*/
pid_t   pPong;                                  /* ->PID du processus fils            */
int     iNbIter = 0;                            /* ->nombre d'iterations realisees    */
/*..............*/
/* declarations */
/*..............*/
pid_t CreateProcess( char *, char **, char **); /* ->creation d'un processus fils avec passage possible d'arguments et de variables d'environnement */
void SignalHandler( int );                      /* ->routine d'interception                                                                         */
/*&&&&&&&&&&&&&&&&&&&&&&&&*/
/* routine d'interception */
/*&&&&&&&&&&&&&&&&&&&&&&&&*/
void SignalHandler( int signal )
{
    if( signal == SIGUSR1)
    {
        printf("PING\n");
        kill( pPong, SIGUSR1);
        iNbIter++;
    };
}
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/* creation d'un processus fils */
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
pid_t   CreateProcess(  char *szPath2Executable,        /* ->chemin vers l'executable  */
                        char **szArgv,                  /* ->arguments                 */
                        char **szEnvp               )   /* ->variables d'environnement */
{
    pid_t   pChild;                 /* ->PID du processus fils */
    /*.......*/
    /* check */
    /*.......*/
    if(szPath2Executable == NULL)
    {
        fprintf(stderr,"ERREUR : CreateProcess() ---> pointeur NULL passe en argument.\n");
        return( -1 );
    };
    /*..........................................*/
    /* tentative de lancement du processus fils */
    /*..........................................*/
    pChild = fork();
    /* echec */
    if( (int)(pChild) < 0 )
    {
        fprintf(stderr,"ERREUR : CreateProcess() ---> appel a fork().\n");
        fprintf(stderr,"         code d'errreur = %d (%s)\n", errno, (char *)(strerror(errno)));
        return( -errno );
    };
    /* reussite et appel de recouvrement */
    if( pChild == 0 )
    {
        execve(szPath2Executable, szArgv, szEnvp);
    };
    /* succes et execution en tant que processus pere */
    return( (int)(pChild));
}
/*#####################*/
/* programme principal */
/*#####################*/
int main( int argc, char *argv[], char *envp[] )
{
	struct sigaction    sa,         /* ->pour l'installation du signal handler                */
                        sa_old;     /* ->sauvegarde de l'ancien signal handler, s'il y a lieu */
    sigset_t            sa_mask;    /* ->masquage eventuel des signaux                        */
    int                 exit_status;
    /*................*/
    /* initialisation */
    /*................*/
    memset( &sa, 0, sizeof(struct sigaction));
    sigemptyset( &sa_mask);
    sa.sa_handler = SignalHandler;
    sa.sa_mask    = sa_mask;
    sa.sa_flags   = 0;
    /*...........................................*/
    /* installation de la routine d'interception */
    /*...........................................*/
    if( sigaction(SIGUSR1, &sa, &sa_old) < 0 )
    {
        fprintf(stderr,"ERREUR : %s.main() ---> appel a sigaction()\n", argv[0]);
        fprintf(stderr,"         code d'erreur %d (%s)\n", errno, (char *)(strerror(errno)));
        return( -errno );
    };
    /*.............................*/
    /* lancement du processus fils */
    /*.............................*/
    if( (int)(pPong = CreateProcess(PATH2_EXECUTABLE, argv, envp)) < 0 )
    {
        fprintf(stderr,"ERREUR : %s.main() ---> appel a CreateProcess()\n", argv[0]);
        fprintf(stderr,"         code d'erreur %d (%s)\n", errno, (char *)(strerror(errno)));
        return( -errno );
    };
    /*.............................................*/
    /* attente pour laisser au processus fils le   */
    /* temps d'installer sa routine d'interception */
    /* (approche naive...)                         */
    /*.............................................*/
    usleep( SLEEP_TIME );
    /* emission du premier signal */
    kill( pPong, SIGUSR1);
    /* attente de signaux */
    do
    {
        pause();
    } while (iNbIter < MAX_ITER);
    wait( &exit_status);
    /* fini */
	return( 0 );
}

	
