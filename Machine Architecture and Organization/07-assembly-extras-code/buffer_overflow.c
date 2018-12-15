// Sample of what used to work as a buffer overflow attack. This now
// FAILS for 2 reasons on modern Linux
// 
// 1. gcc inserts stack protection mechanisms to detect 'stack
//    smashing'. Disable them with
//    gcc -fno-stack-protector buffer_overflow.c 
// 
// 2. The linux kernel randomizes the memory layout of programs from
//    run to run making it nearly impossible to predict the address of a
//    given function. This requires root access to disable and should be
//    done cautiously. See
//    https://stackoverflow.com/questions/2340259/how-to-turn-off-gcc-compiler-optimization-to-enable-buffer-overflow
//    for info.

#include <stdio.h>
void never(){
  printf("This should never happen\b");
  return;
}

int main(){
  union {
    long addr;
    char str[9];
  } never_info;
  never_info.addr = (long) never;
  never_info.str[8] = '\0';

  printf("Address of never: %0p\n",never_info.addr);
  printf("Address as string: %s\n",never_info.str);

  printf("Enter a string: ");
  char buf[4];
  fscanf(stdin,"%s",buf);
  // By entering the correct length of string followed by the ASCII
  // representation of the address of never(), one might be able to
  // get that function to run (on windows...)

  printf("You entered: %s\n",buf);

  return 0;
}
