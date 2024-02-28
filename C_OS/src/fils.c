#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(void){
    int i;
    for(i=0; i<100; i++){
        printf("%lf\n", sin(i));
    }
    return 0;
}