/*====================================================*/
/* programme pour la modification du debit d'entree   */
/* dans la cuve.                                      */
/*____________________________________________________*/
/* Jacques BOONAERT-LEPERS  evaluation AMSE 2023-2024 */
/*====================================================*/
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>
#include <string.h>
#include <math.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
/*............................*/
/* constante de l'application */
/*............................*/
#define DEBIT       "DEBIT"
#define CONSIGNE    "CONSIGNE"
#define NIVEAU      "NIVEAU"
/*...................*/
/* prototypes locaux */
/*...................*/
void usage( char *);           /* ->aide de ce programme                */
/*&&&&&&&&&&&&&&&&&&&&&&*/
/* aide de ce programme */
/*&&&&&&&&&&&&&&&&&&&&&&*/
void usage( char *pgm_name )
{
  if( pgm_name == NULL )
  {
    exit( -1 );
  };
  printf("%s <coefK>\n", pgm_name );
  printf("modifie le coefK du debit entrant\n");
  printf("<coefK> : coefficient de proportionnalité de la réponse\n");
  printf("\n");
  printf("exemple : \n");
  printf("%s 5\n", pgm_name );
  printf("impose 5 comme nouveau coefK pour la boucle fermée\n");
}
/*#####################*/
/* programme principal */
/*#####################*/
int main( int argc, char *argv[])
{
  double                coefK;  /* ->coefK a ecrire dans la zone  */
  double                *qe;      /* ->pointeur sur la zone partagee */
  int                   fd;      /* ->"file descriptor" sur la zone partagee */
  /* verification des arguments */
  if( argc != 2 )
  {
    usage( argv[0] );
    return( 0 );
  };
  /* recuperation des arguments */
  if( sscanf(argv[1],"%lf", &coefK ) == 0)
  {
    printf("ERREUR : probleme de format des arguments\n");
    printf("         passe en ligne de commande.\n");
    usage( argv[0] );
    return( 0 );
  };
  /*................*/
  /* initialisation */
  /*................*/
  
}

  
