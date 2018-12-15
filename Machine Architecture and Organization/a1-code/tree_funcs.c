#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tree.h"

void bst_init(bst_t *tree){
  tree->root = NULL;
  tree->size = 0;
  return;
}

int bst_insert(bst_t *tree, char name[]){
  int i = bst_find(tree, name);
  if(i == 1){
    return 0;
  }
  node_t *result = node_insert(tree->root, name);
  tree->root = result;
  tree->size++;

  return 1;

}

node_t *node_insert(node_t *cur, char name[]){
  int diff;
  if(cur == NULL){
    node_t *new_node = malloc(sizeof(node_t));
    strcpy(new_node->name, name);
    new_node->left = NULL;
    new_node->right= NULL;
    return new_node;
  }
  else{
    diff = strcmp(name, cur->name);
    if(diff < 0){
      cur->left = node_insert(cur->left, name);
    }
    else if(diff > 0){
      cur->right= node_insert(cur->right, name);
    }
  }
  return cur;
}

void bst_print_inorder(bst_t *tree){
  node_print_inorder(tree->root);
  return;
}

void node_print_inorder(node_t *cur){
  if(cur == NULL){
    return;
  }
  node_print_inorder(cur->left);
  printf("%s\n", cur->name);
  node_print_inorder(cur->right);
}

void bst_print_preorder(bst_t *tree){
  node_write_preorder(tree->root, stdout, 0);
}

void bst_save(bst_t *tree, char *fname){
  FILE *fp = fopen(fname, "w");
  node_write_preorder(tree->root, fp, 0);
  fclose(fp);
}


void node_write_preorder(node_t *cur, FILE *out, int depth){
  if(cur == NULL){
    depth--;
    return;
  }
  for(int i = 0; i < depth; i++){
    fprintf(out, " ");
  }
  fprintf(out, "%s\n", cur->name);
  depth++;
  node_write_preorder(cur->left, out, depth);
  node_write_preorder(cur->right, out, depth);
}

int bst_load(bst_t *tree, char *fname ){
  bst_clear(tree);
  FILE *fp = fopen(fname, "r");
  char temp[128];
  while(fscanf(fp,"%s", temp) != EOF){
    bst_insert(tree, temp);
  }
  fclose(fp);
  return 0;
}

void bst_clear(bst_t *tree){
  node_remove_all(tree->root);
  tree->root = NULL; // "free" the stack variable to null
  tree->size = 0;

}

void node_remove_all(node_t *cur){
  if(cur == NULL){
    return;
  }
  node_remove_all(cur->left);
  node_remove_all(cur->right);
  free(cur);
}

int bst_find(bst_t *tree, char name[]){
  int result = node_find(tree->root, name);
  return result;
}

int node_find(node_t *cur, char name[]){
  int diff;

  if(cur == NULL){
    return 0;
  }

    diff = strcmp(name, cur->name);
    if(diff < 0){
      return node_find(cur->left, name);
    }
    else if(diff > 0){
      return node_find(cur->right, name);
    }
    else{
      return 1;
    }


}
