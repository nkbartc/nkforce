#include <stdio.h>
#include <string.h>
#include "list.h"

int main(int argc, char *argv[]){

  printf("Linked List Demo\n");
  printf("Commands:\n");
  printf("  print:          shows the current contents of the list\n");
  printf("  clear:          eliminates all elements from the list\n");
  printf("  exit:           exit the program\n");
  printf("  insert thing:   inserts the given string into the list\n");
  printf("  get index:      get the item at the given index\n");
  printf("  contains thing: determine if the given thing is in the list\n");
  printf("                  (NOT YET IMPLEMENTED)\n");


  char cmd[128];
  list_t list;
  int success;
  list_init(&list);

  while(1){
    printf("list> ");
    success = fscanf(stdin,"%s",cmd);
    if(success==EOF){
      printf("\n");
      break;
    }

    if( strcmp("exit", cmd)==0 ){
      printf("\n");
      break;
    }

    else if( strcmp("insert", cmd)==0 ){
      fscanf(stdin,"%s",cmd);
      success = list_insert(&list, cmd);
      if(!success){
        printf("insert failed\n");
      }
    }

    else if( strcmp("get", cmd)==0 ){
      int index;
      fscanf(stdin,"%d",&index);
      char *ith = list_get(&list, index);
      if(ith == NULL){
        printf("out of bounds\n");
      }
      else {
        printf("%d: %s\n",index,ith);
      }
    }

    else if( strcmp("clear", cmd)==0 ){
      list_clear(&list);
    }

    else if( strcmp("print", cmd)==0 ){
      list_print_all(&list);
    }

    else if( strcmp("contains", cmd)==0){
      char s;
      fscanf(stdin,"%s",&s);
      printf("result: %d\n", list_contains(&list, &s) );
    }


    else{
      printf("uknown command %s\n",cmd);
    }
  }
                      
  return 0;
}
