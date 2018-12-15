#include <stdio.h>


int main(void)
{
   FILE *stream;
   long l;
   int s[100];
   char c;

   stream = fopen("here", "r");

   /* Put in various data. */

   fscanf(stream, "%c", &s[0]);
   //fscanf(stream, "%c", &c);
   //fscanf(stream, "%d", &fp);

   //printf("string = %s\n", s);
   //printf("long double = %ld\n", l);
   //printf("char = %c\n", c);
}
