#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

int *read_text_deltas(char *fname, int *len){
  int temp;
  int count = 0;
  FILE *fp = fopen(fname, "r");
  // If the file cannot be opened with fopen()
  // sets len to -1 and returns NULL.
  if(fp==NULL){
    *len = -1;
    return NULL;
  }

  //while-loop to calculate how many text integers we have in the file
  while(fscanf(fp,"%d", &temp)==1){
    count++;
  }

  //if there are no integers in the file, sets len to -1 and returns NULL.
  if(count == 0){
    *len = -1;
    fclose(fp);
    return NULL;
  }

  //set len to count
  *len = count;


  //allcoate an array of appropriate size
  int *list_num = malloc(count*sizeof(int));
  rewind(fp);

  //use for-loop to store the integers in array
  for(int i = 0; i < count; i++){
    fscanf(fp,"%d", &list_num[i]);
  }

  //use for-loop to do calculation. this gives us the final result
  for(int i = 1; i < count; i++){
    list_num[i] = list_num[i-1] + list_num[i];
  }

  fclose(fp);

  return list_num;

}

int *read_int_deltas(char *fname, int *len){
  FILE *fp = fopen(fname, "r");

  //If the file cannot be opened with fopen()
  //then sets len to -1 and returns NULL.
  if(fp == NULL){
    *len = -1;
    return NULL;
  }

  // If the file is smaller than the size of 1 int,
  //sets len to -1 and returns NULL.
  struct stat sb;
  int result = stat(fname, &sb);
  if(result==-1 || sb.st_size < sizeof(int)){
    *len = -1;
    fclose(fp);
    return NULL;
  }

  int total_bytes = sb.st_size;

  //allcoate an array of appropriate size
  int *list_num = malloc(total_bytes);

  //the length of array is the total_bytes / sizeof(int)
  *len = total_bytes / sizeof(int);

  //for-loop using fread() to store the integers in array
  for(int i = 0; i < total_bytes/4; i++){
    fread(&list_num[i], sizeof(int), 1,fp);
  }

  //use for-loop to do calculation. this gives us the final result
  for(int i = 1; i < total_bytes/4; i++){
    list_num[i] = list_num[i-1] + list_num[i];
  }

  fclose(fp);
  return list_num;

}
