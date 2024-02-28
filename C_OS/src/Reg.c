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
  const char *shm_consigne = CONSIGNE; // Nom de l'objet de mémoire partagée
  const char *shm_debit = DEBIT; // Nom de l'objet de mémoire partagée
  const char *shm_niveau = NIVEAU; // Nom de l'objet de mémoire partagée
  const int shm_size = sizeof(double); // Taille de l'objet de mémoire partagée en octets

  int shm_fd_consigne; // Descripteur de fichier pour la mémoire partagée
  int shm_fd_debit; // Descripteur de fichier pour la mémoire partagée
  int shm_fd_niveau; // Descripteur de fichier pour la mémoire partagée
  void *shm_ptr_consigne; // Pointeur vers la mémoire partagée
  void *shm_ptr_debit; // Pointeur vers la mémoire partagée
  void *shm_ptr_niveau; // Pointeur vers la mémoire partagée

  // Ouverture de l'objet de mémoire partagée
  shm_fd_consigne = shm_open(shm_consigne, O_RDWR, S_IRUSR | S_IWUSR);
  if (shm_fd_consigne == -1) {
      perror("Erreur lors de l'ouverture de l'objet de mémoire partagée");
      exit(EXIT_FAILURE);
  }
  // Ouverture de l'objet de mémoire partagée
  shm_fd_debit = shm_open(shm_debit, O_RDWR, S_IRUSR | S_IWUSR);
  if (shm_fd_debit == -1) {
      perror("Erreur lors de l'ouverture de l'objet de mémoire partagée");
      exit(EXIT_FAILURE);
  }
  // Ouverture de l'objet de mémoire partagée
  shm_fd_niveau = shm_open(shm_niveau, O_RDWR, S_IRUSR | S_IWUSR);
  if (shm_fd_niveau == -1) {
      perror("Erreur lors de l'ouverture de l'objet de mémoire partagée");
      exit(EXIT_FAILURE);
  }

  // Mappage de la mémoire partagée dans l'espace d'adressage du processus
  shm_ptr_consigne = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_consigne, 0);
  shm_ptr_debit = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_debit, 0);
  shm_ptr_niveau = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_niveau, 0);
  if (shm_ptr_consigne == MAP_FAILED) {
      perror("Erreur lors du mappage de la mémoire partagée");
      exit(EXIT_FAILURE);
  }
  if (shm_ptr_debit == MAP_FAILED) {
      perror("Erreur lors du mappage de la mémoire partagée");
      exit(EXIT_FAILURE);
  }
  if (shm_ptr_niveau == MAP_FAILED) {
      perror("Erreur lors du mappage de la mémoire partagée");
      exit(EXIT_FAILURE);
  }

  // Affichage du contenu de la mémoire partagée
  printf("Contenu de la mémoire partagée : %s\n", (double *)shm_ptr_consigne);
  printf("Contenu de la mémoire partagée : %s\n", (double *)shm_ptr_niveau);

  // Modification du contenu de la mémoire partagée
  *shm_ptr_debit = 80.0; //j'ai ounblié

  // Affichage du contenu modifié de la mémoire partagée
  printf("Contenu modifié de la mémoire partagée : %s\n", (char *)shm_debit);

  // Libération de la mémoire partagée
  if (munmap(shm_ptr, shm_size) == -1) {
      perror("Erreur lors de la libération de la mémoire partagée");
      exit(EXIT_FAILURE);
  }

  return 0;
}

  
