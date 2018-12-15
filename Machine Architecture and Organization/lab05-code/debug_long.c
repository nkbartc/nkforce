#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
  union {                       // shared memory between
    long lo;                    // an long (8 bytes) 
    char ch[8];                 // char array (8 bytes)
  } chlo;                       // total size: 4 bytes   

  // Demonstrate that memory can be interpretted as...
  strcpy(chlo.ch,"Dude??");
  printf("lo: %016lx %ld \n",   // as a number
         chlo.lo,chlo.lo);
  printf("ch: %s\n",chlo.ch);

  if(argc < 2){
    printf("need a command line arg: string\n");
    exit(1);
  }
  long lng = 36783801071443;    // what IS lng??
  
  union{
    long lo;
    char ch[8];
  } chlo2;

  strcpy(chlo2.ch, argv[1]);

  if(chlo2.lo == lng){
    printf("Yup, equal!\n");
    return 0;
  }
  else{
    printf("Nope, not equal...\n");
    return -1;
  }
}
