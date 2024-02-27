#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <string.h>

int main() {
    const char *shm_name = "/mon_objet_memoire"; // Nom de l'objet de mémoire partagée
    const int shm_size = 4096; // Taille de l'objet de mémoire partagée en octets

    int shm_fd; // Descripteur de fichier pour la mémoire partagée
    void *shm_ptr; // Pointeur vers la mémoire partagée

    // Création de l'objet de mémoire partagée
    shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
    if (shm_fd == -1) {
        perror("Erreur lors de la création de l'objet de mémoire partagée");
        exit(EXIT_FAILURE);
    }

    // Configuration de la taille de l'objet de mémoire partagée
    if (ftruncate(shm_fd, shm_size) == -1) {
        perror("Erreur lors de la configuration de la taille de l'objet de mémoire partagée");
        exit(EXIT_FAILURE);
    }

    // Mappage de la mémoire partagée dans l'espace d'adressage du processus
    shm_ptr = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
    if (shm_ptr == MAP_FAILED) {
        perror("Erreur lors du mappage de la mémoire partagée");
        exit(EXIT_FAILURE);
    }

    // Utilisation de la mémoire partagée
    sprintf(shm_ptr, "Bonjour, monde OwO !");

    // Affichage de la valeur de la mémoire partagée
    printf("Valeur de la mémoire partagée : %s\n", (char *)shm_ptr);

    // Attente de la saisie d'une touche pour libérer la mémoire partagée
    printf("Appuyez sur une touche pour libérer la mémoire partagée...\n");
    getchar();

    printf("Valeur de la nvl mémoire partagée : %s\n", (char *)shm_ptr);

    // Fermeture et suppression de l'objet de mémoire partagée
    if (munmap(shm_ptr, shm_size) == -1) {
        perror("Erreur lors de la libération de la mémoire partagée");
        exit(EXIT_FAILURE);
    }

    if (shm_unlink(shm_name) == -1) {
        perror("Erreur lors de la suppression de l'objet de mémoire partagée");
        exit(EXIT_FAILURE);
    }

    printf("Mémoire partagée libérée avec succès.\n");

    return 0;
}
