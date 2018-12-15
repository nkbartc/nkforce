#include "matvec.h"
#include <stdlib.h>

  // from the sizes, we can see that the numbers are all multiples of 2.
  // Hence, we can use unroll x2, x4, or x8 or .... to avoid using
  // "cleanup loop".

int optimized_matrix_trans_mult_vec(matrix_t mat, vector_t vec, vector_t res){
  //set everything to 0
  for (int x = 0; x < mat.cols; x++) {
    VSET(res, x, 0);
  }

  int limit = mat.cols - (mat.cols % 4);

  for(int i=0; i<mat.rows; i++){
    int j = 0;
    for(; j<limit; j+=4){ // unroll x4 for pipelining
      int prod0 = MGET(mat, i, j) * VGET(vec, i);
      int curr0 = VGET(res, j);
      int next0 = curr0 + prod0;
      VSET(res, j, next0);

      int prod1 = MGET(mat, i, j+1) * VGET(vec, i);
      int curr1 = VGET(res, j+1);
      int next1 = curr1 + prod1;
      VSET(res, j+1, next1);

      int prod2 = MGET(mat, i, j+2) * VGET(vec, i);
      int curr2 = VGET(res, j+2);
      int next2 = curr2 + prod2;
      VSET(res, j+2, next2);

      int prod3 = MGET(mat, i, j+3) * VGET(vec, i);
      int curr3 = VGET(res, j+3);
      int next3 = curr3 + prod3;
      VSET(res, j+3, next3);
    }
    // cleanup loop taking care of any remainders.
    //
    for(; j<mat.cols; j++){
      int prod0 = MGET(mat, i, j) * VGET(vec, i);
      int curr0 = VGET(res, j);
      int next0 = curr0 + prod0;
      VSET(res, j, next0);
    }
  }
  return 0;
}
