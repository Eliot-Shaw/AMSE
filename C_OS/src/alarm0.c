/*=================================================*/
/* exemple d'utilisation de la notion d'alarme     */
/* (alarme ~ signal que le processus s'auto-envoie */
/* par l'entremise du systeme d'exploitation)      */
/*=================================================*/
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <errno.h>
/* constantes */
#define DELAY	10		/* ->delai de saise en secondes                */
/* prototypes */
void alarm_handler( int );	/* ->gestionnaire de signal associe a l'alarme */
/* gestionnaire de signal associe a l'alarme */
void alarm_handler( int signal )
{
  if( signal == SIGALRM )
  {
    printf("trop tard !!!!\n");
    exit( 0 );
  };
}
/* programme principal : on a qqs secondes pour saisir une valeur... */
int main( int argc, char *argv[] )
{
  char 	rep;			/* ->caractere saisi par l'utilisateur          */
  struct sigaction sa;		/* ->pour definir le handler de signal          */
  sigset_t 	blocked;	/* ->ensembe des signaux eventuellement bloques */
  /* initialisation du masquage des signaux */
  sigemptyset( &blocked );
  /* parametrage du fonctionnement du handler */
  sa.sa_handler = alarm_handler;	/* ->routine a appeler lors de l'occurrence du signal */
  sa.sa_flags = 0;			/* ->conservation des macanismes par defaut           */
  sa.sa_mask  = blocked;		/* ->liste des signaux a masquer                      */
  /* installation du gestion AVANT de demarrer l'alarme... */
  sigaction( SIGALRM, &sa, NULL );
  do
  {
    alarm( DELAY ); /* ->au bout de DELAY, le signal SIGALRM sera recu ! */
    printf("vous disposez de %d secondes pour saisir un caractere...\n",  DELAY );
    fflush( stdin );
    scanf("%c", &rep );
    /* desarmement de l'alarme */
    alarm( 0 );
    printf("OK\n");
  }
  while( 1 );
  return( 0 );
}

 