#include <stdio.h>

void swap(int *a, int *b){
  int tmp = *a;
  *a = *b;
  *b = tmp;
  return;
}

int main(){
  int x = 21;
  int y = 20;
  swap(&x, &y);
  printf("%d %d\n",x,y);
  return 0;
}                          

  
