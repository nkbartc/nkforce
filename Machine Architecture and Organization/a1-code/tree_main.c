#include <stdio.h>
#include <string.h>
#include "tree.h"

// global variable to control echoing, 0: echo off, 1: echo on
int ECHO = 0;

// Print the given string if echoing is turned on
void echo(char *s){
  if(ECHO){
    printf("%s",s);
  }
}


int main(int argc, char *argv[]){

if(argc > 1 && strcmp("-echo",argv[1])==0) {
    ECHO=1;
}



  printf("BST Demo\n");
  printf("Commands:\n");
  printf("  print:          shows contents of the tree in sorted order\n");
  printf("  show:           shows contents in pre-order indicating its structure\n");
  printf("  clear:          eliminates all elements from the tree\n");
  printf("  quit:           exit the program\n");
  printf("  add <name>:     inserts the given string into the tree, duplicates ignored\n");
  printf("  find <name>:    prints FOUND if the name is in the tree, NOT FOUND otherwise\n");
  printf("  save <file>:    writes the contents of the tree in post order to the given file\n");
  printf("  load <file>:    clears the current tree and loads the one in the given file\n");

  char cmd[128];
  char name[128];
  char address[128];
  bst_t tree;
  bst_init(&tree);
  int success;

  while(1){
    printf("BST> ");
    success = fscanf(stdin,"%s",cmd);
    if(success==EOF){
      break;
    }

    if( strcmp("print", cmd)==0 ){
      echo(cmd); echo("\n");
      bst_print_inorder(&tree);
    }

    else if( strcmp("save", cmd)==0 ){
      echo(cmd);
      fscanf(stdin,"%s",address);
      echo(" "); echo(address); echo("\n");
      bst_save(&tree, address);
    }

    else if( strcmp("load", cmd)==0 ){
      echo(cmd);
      fscanf(stdin,"%s",address);
      echo(" "); echo(address); echo("\n");
      bst_load(&tree, address);
    }

    else if( strcmp("show", cmd)==0 ){
      echo(cmd);echo("\n");
      bst_print_preorder(&tree);
    }

    else if( strcmp("clear", cmd)==0 ){
      echo(cmd);echo("\n");
      bst_clear(&tree);
    }

    else if( strcmp("add", cmd)==0 ){
      echo(cmd);
      fscanf(stdin,"%s",name);
      echo(" "); echo(name); echo("\n");
      bst_insert(&tree, name);

    }

    else if( strcmp("find", cmd)==0 ){
      echo(cmd);
      fscanf(stdin,"%s",name);
      echo(" "); echo(name); echo("\n");
      success = bst_find(&tree, name);
      if(success == 0){
        printf("NOT FOUND\n");
      }
      else{
      printf("FOUND\n");
      }
    }

    else if( strcmp("quit", cmd)==0 ){
      echo(cmd);echo("\n");
      printf("\n");
      break;
    }

    else{
      printf("uknown command %s\n",cmd);
    }
  }
  bst_clear(&tree);
  return 0;
}
