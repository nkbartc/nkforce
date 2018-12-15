#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "lcd.h"

int main(int argc, char **argv){
  int test;
  test = 0b01 >> 31;
  printf("%b", test);
}
