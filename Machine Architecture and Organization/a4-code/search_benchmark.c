#include "search.h"
#include "time.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char *argv[]){

  if(argc < 4){
    printf("usage: %s <rows> <cols>\n",argv[0]);
    return 1;
  }
  int min = atoi(argv[1]);
      min = 1 << min;
  int max = atoi(argv[2]);
      max = 1 << max;
  int rep = atoi(argv[3]);

  clock_t begin, end;
  char test[4] = "1111"; //default condition; do all searching algorithms

  // if the user would like to use specific searching algorithms
  if(argc == 5){
    char* which = argv[4];
    int which_len = strlen(argv[4]);
    test[0] = '0';
    test[1] = '0';
    test[2] = '0';
    test[3] = '0';

    for(int i = 0; i < which_len; i++){
      if(which[i] == 'a'){
        test[0] = '1';
      }
      else if(which[i] == 'l'){
        test[1] = '1';
      }
      else if(which[i] == 'b'){
        test[2] = '1';
      }
      else if(which[i] == 't'){
        test[3] = '1';
      }
    }
  }

  // lebels
  printf("  LENGTH SEARCHES");

  if(test[0] == '1'){
    printf("      array");
  }
  if(test[1] == '1'){
    printf("       list");
  }
  if(test[2] == '1'){
    printf("     binary");
  }
  if(test[3] == '1'){
    printf("       tree");
  }
  printf("\n");

  for(int i = min; i <= max; i *= 2){
    int    *a = make_sequential_array (i);
    list_t *l = make_sequential_list  (i);
    bst_t  *b = make_sequential_tree  (i);
    double time_las = 0;
    double time_ls  = 0;
    double time_bas = 0;
    double time_bts = 0;
    // An outer loop over the number of repetitions
    for(int j = 0; j < rep; j++){
      // A first inner loop over successful queries 0, 50, 1,51,2,52, …,49,99
      for(int k1 = 0; k1 < (i/2); k1++){
        begin = clock();
        linear_array_search(a, i, k1);
        linear_array_search(a, i, k1 + i/2);
        end = clock();
        time_las += ((double) end - begin) / CLOCKS_PER_SEC;

        begin = clock();
        linkedlist_search(l, i, k1);
        linkedlist_search(l, i, k1 + i/2);
        end = clock();
        time_ls += ((double) end - begin) / CLOCKS_PER_SEC;

        begin = clock();
        binary_array_search(a, i, k1);
        binary_array_search(a, i, k1 + i/2);
        end = clock();
        time_bas += ((double) end - begin) / CLOCKS_PER_SEC;

        begin = clock();
        binary_tree_search(b, i, k1);
        binary_tree_search(b, i, k1 + i/2);
        end = clock();
        time_bts += ((double) end - begin) / CLOCKS_PER_SEC;

      }
      // A second inner loop over failing queries -1,-51,-2,-52,…,-50,-100
      for(int k2 = -1; k2 >= -(i/2); k2--){
        begin = clock();
        linear_array_search(a, i, k2);
        linear_array_search(a, i, k2 - i/2);
        end = clock();
        time_las += ((double) end - begin) / CLOCKS_PER_SEC;

        begin = clock();
        linkedlist_search(l, i, k2);
        linkedlist_search(l, i, k2 - i/2);
        end = clock();
        time_ls += ((double) end - begin) / CLOCKS_PER_SEC;

        begin = clock();
        binary_array_search(a, i, k2);
        binary_array_search(a, i, k2 - i/2);
        end = clock();
        time_bas += ((double) end - begin) / CLOCKS_PER_SEC;

        begin = clock();
        binary_tree_search(b, i, k2);
        binary_tree_search(b, i, k2 - i/2);
        end = clock();
        time_bts += ((double) end - begin) / CLOCKS_PER_SEC;
      }
    }
    // print the results
    printf("%8d %8d", i, i*rep*2);
    if(test[0] == '1'){
      printf(" %.4e", time_las);
    }
    if(test[1] == '1'){
      printf(" %.4e", time_ls);
    }
    if(test[2] == '1'){
      printf(" %.4e", time_bas);
    }
    if(test[3] == '1'){
      printf(" %.4e", time_bts);
    }
    printf("\n");
    // free the data structures
    free(a);
    list_free(l);
    bst_free(b);
  }

  return 0;
}
