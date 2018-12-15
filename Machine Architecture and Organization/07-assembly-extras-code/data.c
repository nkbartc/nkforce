// Demonstrate a few assembly constructs for data like arrays and
// structs

#include <stdio.h>

typedef struct {
  int i; short s; 
  char c[2]; 
} foo_t;

foo_t foo;

int main(){
  int i,j;

  // ARRAYS
  int arr[10] = {};
  scanf("%d",&i);

  arr[i] = 12;
  // movl $12,(%rdi,%rsi,4)

  int x = arr[j];
  // movl (%rdi,%rcx,4),%r8

  // STRUCTS
  foo_t *f = &foo;
  f->s = (short) i;

  short sh = f->s;
  // movw 4(%rdi),%si

  scanf("%d",&i);
  f->c[i] = 'X';
  // movb $88, 6(%rix,%rax)

  printf("%d\n",f->c[1]);
  return 0;
}
