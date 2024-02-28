/*====================================================*/
/* programme pour la modification de la hauteur voulue*/
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
#define STOPCUVE "STOPCUVE"
/*...................*/
/* prototypes locaux */
/*...................*/
void usage(char *); /* ->aide de ce programme                */
/*#####################*/
/* programme principal */
/*#####################*/
int main(int argc, char *argv[])
{
    double valeur; /* ->valeur a ecrire dans la zone  */
    double *yt;    /* ->pointeur sur la zone partagee */
    int fh;        /* ->"file descriptor" sur la zone partagee */
    /* verification des arguments */
    if (argc != 2)
    {
        usage(argv[0]);
        return (0);
    };
    /* recuperation des arguments */
    if (sscanf(argv[1], "%lf", &valeur) == 0)
    {
        printf("ERREUR : probleme de format des arguments\n");
        printf("         passe en ligne de commande.\n");
        usage(argv[0]);
        return (0);
    };
    /*................*/
    /* initialisation */
    /*................*/
    /* creation de la zone partagee */
    fh = shm_open(STOPCUVE, O_RDWR | O_CREAT, 0600);
    if (fh < 0)
    {
        fprintf(stderr, "ERREUR : main() ---> appel a shm_open()\n");
        fprintf(stderr, "        code d'erreur %d (%s)\n",
                errno,
                (char *)(strerror(errno)));
        return (-errno);
    };
    ftruncate(fh, sizeof(double));
    yt = (double *)mmap(NULL,
                        sizeof(double),
                        PROT_READ | PROT_WRITE,
                        MAP_SHARED,
                        fh,
                        0);
    *yt = valeur; /* ->ecriture effective dans la zone partagee */
    close(fh);
    return (0); /* ->on n'arrive pas jusque la en pratique */
}
