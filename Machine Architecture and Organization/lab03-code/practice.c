#include <stdio.h>
#include <stdlib.h>

int main() {
  // FILE *fin = fopen("short.int","w");
  //
  // char *buff = "abcde";

  // char *num = malloc(20*sizeof(char));

  // for(int i = 0; i<20; i++){
  // fread(&num[i], sizeof(char),1, fin);
  // }

  // int num[21];
  // fscanf(fin, "%d", &num);
  // fread(&num, sizeof(int), 4,fin);

  // fwrite(&buff[1], sizeof(char), sizeof(buff), fin);

  // for(int i = 0; i < 21; i++){
  //   fscanf(fin, "%d", &num[i]);
  // }

  // printf("%d\n", num);

  // for (int i = 0; i < 21; i++) {
  //   printf("%d\n", num[i]);
  // }
  //
  // fclose(fin);
  // int temp[3] = {1,2,3};
  //
  // int *head = temp;
  //
  // int *elem = &temp[2];
  //
  // printf("%p\n%p\n", head, elem);

  int a = 2;

  a = a >> 2;

  printf("%d",a);

  return 0;
}
