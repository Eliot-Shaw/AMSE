/* ce processus recoit le signal SIGUSR2 */
/* en reponse, il affiche "PONG" et envoie */
/* le signal SIGUSR1 a son pere  pour un */
/* total de 20 iterations */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <errno.h>

/* declarations */
void SignalHandler( int );	/* ->signal handler / routine d'interception */
/* globales */
pid_t	pParent;		/* ->PID du processus pere */
int 	i = 0;			/* ->compteur d'iterations */
/*&&&&&&&&&&&&&&&&&&&&&&&&*/
/* routine d'interception */
/*&&&&&&&&&&&&&&&&&&&&&&&&*/
void SignalHandler( int signal )	/* ->le numero de signa recu */
{
	if( signal == SIGUSR1) 
	{
		printf("PONG\n");
		kill(pParent, SIGUSR1);
		i++;
	};
}
/* programme principal */
int main( void )
{
	struct sigaction	sa,		/* ->definition de la fonction a appeler a reception du signal */
				sa_old;		/* ->sauvegarde de l'ancien "comportement" */
	sigset_t		sa_mask;	/* ->liste des signaux a "masquer" */
	/* initialisation */
	memset( &sa, 0, sizeof( struct sigaction));	/* ->RAZ de la structure  */
	sigemptyset(&sa_mask);			/* ->creation d'une liste de signaux vide */

	sa.sa_handler = SignalHandler;
	sa.sa_mask    = sa_mask;
	sa.sa_flags   = 0;
	pParent = getppid();
	/* installation de la routine d'interception */
	if( sigaction( SIGUSR1, &sa, &sa_old ) < 0 )
	{
		fprintf(stderr,"ERREUR : appel a sigaction()\n");
		fprintf(stderr,"         code d'erreur = %d (%s)\n", errno, (char *)(strerror(errno)));
		return( -errno );
	};
	/* a ne fait rien a part attendre un signal */
	do
	{
		pause();
	}
	while( i < 10 );
	printf("FIN...\n");

	return( 0 );
}

	
