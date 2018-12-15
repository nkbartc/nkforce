// Several manually unrolled versions of sum_rangeX() to demonstrate
// different properties.

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>               // for clock() and other functions
#include <stdio.h>
#include <sys/time.h>


void sum_rangeA(long stop, long *ans)
{
  long sum=0, i;
  for(i=0; i<stop; i++){
    sum += i+0;
  }
  *ans = sum;
}


void sum_rangeB(long stop, long *ans)
{
  long sum = 0, i;
  for(i=0; i<stop-3; i+=3){
    sum += (i+0);
    sum += (i+1);
    sum += (i+2);
  }
  for(; i<stop; i++){
    sum += i;
  }
  *ans = sum;
}

void sum_rangeC(long stop, long *ans)
{
  long sum0=0, sum1=0, sum2=0, i;
  for(i=0; i<stop-3; i+=3){
    sum0 += (i+0);
    sum1 += (i+1);
    sum2 += (i+2);
  }
  for(; i<stop; i++){
    sum0 += i;
  }
  *ans = sum0 + sum1 + sum2;
}


int main(int argc, char *argv[]){
  if(argc < 2){
    printf("usage: %s <stop> \n",argv[0]);
    return -1;
  }

  long stop  = atol(argv[1]);
  clock_t begin, end;
  double cpu_time;

  long sumA;
  begin = clock();
  sum_rangeA(stop, &sumA);
  end = clock();
  cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
  printf("sum_rangeA: %.4e secs\n",cpu_time);    

  long sumB;
  begin = clock();
  sum_rangeB(stop, &sumB);
  end = clock();
  cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
  printf("sum_rangeB: %.4e secs\n",cpu_time);    

  long sumC;
  begin = clock();
  sum_rangeC(stop, &sumC);
  end = clock();
  cpu_time = ((double) (end - begin)) / CLOCKS_PER_SEC;
  printf("sum_rangeC: %.4e secs\n",cpu_time);    

  assert(sumA==sumB);
  assert(sumB==sumC);
  return 0;
}
