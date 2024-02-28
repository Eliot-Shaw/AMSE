/*====================================================*/
/* programme pour l'arrêt des programmes              */
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
/*#####################*/
/* programme principal */
/*#####################*/
int main(int argc, char *argv[])
{
    /*................*/
    /* initialisation */
    /*................*/
    int *val;
    int fp;

    /* creation de la zone partagee */
    fp = shm_open(STOPCUVE, O_RDWR | O_CREAT, 0600);
    if (fp < 0)
    {
        fprintf(stderr, "ERREUR : main() ---> appel a shm_open()\n");
        fprintf(stderr, "        code d'erreur %d (%s)\n",
                errno,
                (char *)(strerror(errno)));
        return (-errno);
    };
    ftruncate(fp, sizeof(double));
    val = (int *)mmap(NULL,
                      sizeof(double),
                      PROT_READ | PROT_WRITE,
                      MAP_SHARED,
                      fp,
                      0);
    *val = 1; /* ->ecriture effective dans la zone partagee */
    printf("valeur d'arret passé à %d\n", *val),
        close(fp);
    return (0);
}
