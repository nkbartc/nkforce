// Several manually unrolled versions of sum_rangeX() to demonstrate
// different properties.

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>               // for clock() and other functions
#include <stdio.h>
#include <sys/time.h>


long sum_evensA(int *arr, long len){
  long sum=0;
  for(int i=0; i<len; i++){
    if(i % 2 == 0){
      sum += arr[i];
    }
  }
  return sum;
}

long sum_evensB(int *arr, long len){
  long sum=0;
  long fairness=0;
  for(int i=0; i<len; i+=2){
    fairness = (i % 2) == 0;
    sum += arr[i];
  }
  return sum + fairness;
}

int main(int argc, char *argv[]){
  if(argc < 2){
    printf("usage: %s <stop> \n",argv[0]);
    return -1;
  }

  long len  = atol(argv[1]);
  int *arr = malloc(sizeof(int)*len);
  arr[0] = 0;
  for(long i=1; i<len; i++){
    arr[i] = arr[i-1]+i;
  }

  clock_t begin, end;
  double cpu_time;

  begin = clock();
  long sumA = sum_evensA(arr,len);
  end = clock();
  cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
  printf("sum_rangeA: %.4e secs\n",cpu_time);

  begin = clock();
  long sumB = sum_evensB(arr,len);
  end = clock();
  cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
  printf("sum_rangeB: %.4e secs\n",cpu_time);

  // assert(sumA==sumB);
  return sumA+sumB;
}
