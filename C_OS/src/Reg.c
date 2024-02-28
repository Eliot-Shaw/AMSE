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
#define DEBIT "DEBIT"
#define CONSIGNE "CONSIGNE"
#define NIVEAU "NIVEAU"
/*...................*/
/* prototypes locaux */
/*...................*/
void usage(char *);         /* ->aide de ce programme                */
void cycl_alm_handler(int); /* ->gestionnaire pour l'alarme cyclique   */
/*&&&&&&&&&&&&&&&&&&&&&&*/
/* aide de ce programme */
/*&&&&&&&&&&&&&&&&&&&&&&*/
void usage(char *pgm_name)
{
    if (pgm_name == NULL)
    {
        exit(-1);
    };
    printf("%s <coefK> <Te>\n", pgm_name);
    printf("modifie le coefK du debit entrant\n");
    printf("<coefK> : coefficient de proportionnalité de la réponse\n");
    printf("\n");
    printf("modifie le Te temps echantillonage\n");
    printf("<Te> : le temps echantillonage\n");
    printf("\n");
    printf("exemple : \n");
    printf("%s 5 0.01\n", pgm_name);
    printf("impose 5 comme nouveau coefK pour la boucle fermée et 0.01 le temps d'echantillonage\n");
}
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/* gestionnaire de l'alarme cyclique */
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
void cycl_alm_handler(int signal)
{
    /*...............................*/
    /* mise a jour entree / sortie : */
    /*...............................*/
    if (signal == SIGALRM)
    {
        (*v) += Te * (*qe);
        (*y) = (*v) / s;
    };
    /*................................*/
    /* arret du processus a reception */
    /* de SIGUSR1                     */
    /*................................*/
    if (signal == SIGUSR1)
    {
        GoOn = 0;
    };
}
/*#####################*/
/* programme principal */
/*#####################*/
int main(int argc, char *argv[])
{
    const char *shm_consigne = CONSIGNE; // Nom de l'objet de mémoire partagée
    const char *shm_debit = DEBIT;       // Nom de l'objet de mémoire partagée
    const char *shm_niveau = NIVEAU;     // Nom de l'objet de mémoire partagée
    const int shm_size = sizeof(double); // Taille de l'objet de mémoire partagée en octets

    int shm_fd_consigne;    // Descripteur de fichier pour la mémoire partagée
    int shm_fd_debit;       // Descripteur de fichier pour la mémoire partagée
    int shm_fd_niveau;      // Descripteur de fichier pour la mémoire partagée
    void *shm_ptr_consigne; // Pointeur vers la mémoire partagée
    void *shm_ptr_debit;    // Pointeur vers la mémoire partagée
    void *shm_ptr_niveau;   // Pointeur vers la mémoire partagée

    double coefK;            /* ->coefK a ecrire dans la zone  */
    double Te;            /* ->coefK a ecrire dans la zone  */
    struct sigaction sa,     /* ->configuration de la gestion de l'alarme */
        sa_old;              /* ->ancienne config de gestion d'alarme     */
    sigset_t blocked;        /* ->liste des signaux bloques               */
    struct itimerval period; /* ->periode de l'alarme cyclique            */
    /* verification des arguments */
    if (argc != 2)
    {
        usage(argv[0]);
        return (0);
    };
    /* recuperation des arguments */
    if((sscanf(argv[1], "%lf", &coefK) == 0) || (sscanf(argv[2], "%lf", &Te) == 0))
    {
        printf("ERREUR : probleme de format des arguments\n");
        printf("         passe en ligne de commande.\n");
        usage(argv[0]);
        return (0);
    };
    /*................*/
    /* initialisation */
    /*................*/
    

    // Ouverture de l'objet de mémoire partagée
    shm_fd_consigne = shm_open(shm_consigne, O_RDWR, S_IRUSR | S_IWUSR);
    if (shm_fd_consigne == -1)
    {
        perror("Erreur lors de l'ouverture de l'objet de mémoire partagée");
        exit(EXIT_FAILURE);
    }
    // Ouverture de l'objet de mémoire partagée
    shm_fd_debit = shm_open(shm_debit, O_RDWR, S_IRUSR | S_IWUSR);
    if (shm_fd_debit == -1)
    {
        perror("Erreur lors de l'ouverture de l'objet de mémoire partagée");
        exit(EXIT_FAILURE);
    }
    // Ouverture de l'objet de mémoire partagée
    shm_fd_niveau = shm_open(shm_niveau, O_RDWR, S_IRUSR | S_IWUSR);
    if (shm_fd_niveau == -1)
    {
        perror("Erreur lors de l'ouverture de l'objet de mémoire partagée");
        exit(EXIT_FAILURE);
    }

    // Mappage de la mémoire partagée dans l'espace d'adressage du processus
    shm_ptr_consigne = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_consigne, 0);
    shm_ptr_debit = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_debit, 0);
    shm_ptr_niveau = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_niveau, 0);
    if (shm_ptr_consigne == MAP_FAILED)
    {
        perror("Erreur lors du mappage de la mémoire partagée");
        exit(EXIT_FAILURE);
    }
    if (shm_ptr_debit == MAP_FAILED)
    {
        perror("Erreur lors du mappage de la mémoire partagée");
        exit(EXIT_FAILURE);
    }
    if (shm_ptr_niveau == MAP_FAILED)
    {
        perror("Erreur lors du mappage de la mémoire partagée");
        exit(EXIT_FAILURE);
    }

    // Affichage du contenu de la mémoire partagée
    printf("Contenu de la mémoire partagée : %s\n", (double *)shm_ptr_consigne);
    printf("Contenu de la mémoire partagée : %s\n", (double *)shm_ptr_niveau);

    // Modification du contenu de la mémoire partagée
    *shm_ptr_debit = 80.0; // j'ai ounblié

    // Affichage du contenu modifié de la mémoire partagée
    printf("Contenu modifié de la mémoire partagée : %s\n", (char *)shm_debit);

    // Gestion de l'alarme
    sigemptyset(&blocked);
    memset(&sa, 0, sizeof(sigaction)); /* ->precaution utile... */
    sa.sa_handler = cycl_alm_handler;
    sa.sa_flags = 0;
    sa.sa_mask = blocked;
    /* installation du gestionnaire de signal */
    sigaction(SIGALRM, &sa, NULL);
    /* initialisation de l'alarme  */
    period.it_interval.tv_sec = (int)(Te);
    period.it_interval.tv_usec = (int)((Te - (int)(Te)) * 1e6);
    period.it_value.tv_sec = (int)(Te);
    period.it_value.tv_usec = (int)((Te - (int)(Te)) * 1e6);
    /* demarrage de l'alarme */
    setitimer(ITIMER_REAL, &period, NULL);
    /* on ne fait desormais plus rien d'autre que */
    /* d'attendre les signaux                     */
    printf("SIMULATION :\n");
    do
    {
        pause();
        printf("qe = %lf\t v = %lf y = %lf\n", *qe, *v, *y);
    } while (GoOn == 1);

    // Libération de la mémoire partagée consigne
    if (munmap(shm_ptr_consigne, shm_size) == -1)
    {
        perror("Erreur lors de la libération de la mémoire partagée");
        exit(EXIT_FAILURE);
    }
    // Libération de la mémoire partagée debit
    if (munmap(shm_ptr_debit, shm_size) == -1)
    {
        perror("Erreur lors de la libération de la mémoire partagée");
        exit(EXIT_FAILURE);
    }
    // Libération de la mémoire partagée niveau
    if (munmap(shm_ptr_niveau, shm_size) == -1)
    {
        perror("Erreur lors de la libération de la mémoire partagée");
        exit(EXIT_FAILURE);
    }

    return 0;
}
