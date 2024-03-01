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

    // Ouverture de l'objet de mémoire partagée
    shm_fd = shm_open(shm_name, O_RDWR, S_IRUSR | S_IWUSR);
    if (shm_fd == -1) {
        perror("Erreur lors de l'ouverture de l'objet de mémoire partagée");
        exit(EXIT_FAILURE);
    }

    // Mappage de la mémoire partagée dans l'espace d'adressage du processus
    shm_ptr = mmap(NULL, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
    if (shm_ptr == MAP_FAILED) {
        perror("Erreur lors du mappage de la mémoire partagée");
        exit(EXIT_FAILURE);
    }

    // Affichage du contenu de la mémoire partagée
    printf("Contenu de la mémoire partagée : %s\n", (char *)shm_ptr);

    // Modification du contenu de la mémoire partagée
    strcpy((char *)shm_ptr, "Hello world UwU");

    // Affichage du contenu modifié de la mémoire partagée
    printf("Contenu modifié de la mémoire partagée : %s\n", (char *)shm_ptr);

    // Libération de la mémoire partagée
    if (munmap(shm_ptr, shm_size) == -1) {
        perror("Erreur lors de la libération de la mémoire partagée");
        exit(EXIT_FAILURE);
    }

    return 0;
}
