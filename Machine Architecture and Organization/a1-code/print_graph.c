#include <stdio.h>
#include <stdlib.h>

void print_graph(int *data, int len, int max_height){

  int min, max, range;
  float units_per_height;

  //default min and max for array holding one element
  min = data[0];
  max = data[0];

  //for-loop to find min and max
  for(int i = 1; i < len; i++)
  {
    if(data[i] > max)
    {
      max = data[i];
    }

    if(data[i] < min)
    {
      min = data[i];
    }
  }

  //calculate range and units_per_height
  range = max - min;
  units_per_height = (float)range / (float)max_height;

  //print some basic infomations of the graph
  printf("length: %d\n", len);
  printf("min: %d\n", min);
  printf("max: %d\n", max);
  printf("range: %d\n", range);
  printf("max_height: %d\n", max_height);
  printf("units_per_height: %.2f\n", units_per_height);

  //graphing now
  //the top graphing start
  int temp; // temp is used for top and bottom,
            // using % 5 to determine if a number is a multiple of 5
  printf("     ");
  for(int i = 0; i < len; i++)
  {
    temp = i % 5;
    if(temp == 0)
    {
      printf("+");
    }
    else
    {
      printf("-");
    }
  }
  printf("\n"); //this ends top graphing

  //the main body graphing starts
  int level, unit;
  level = max_height;

  while(level >= 0) //loop 1 print level number and vertical bar
  {
    unit = min + level * units_per_height;
    printf("%3d |", unit);

    for(int i = 0; i < len; i++) //loop 2 visit every element in data and print either X or space
    {
      if(data[i] >= unit)
      {
        printf("X");
      }
      else
      {
        printf(" ");
      }
    }
    level --; // go to the lower level
    printf("\n");
  }
  //this ends main body graphing
  //bottom axes graphing start
  //the +----+ stuff
  printf("     ");
  for(int i = 0; i < len; i++)
  {
    temp = i % 5;
    if(temp == 0)
    {
      printf("+");
    }
    else
    {
      printf("-");
    }
  }
  printf("\n"); //the +----+ stuff ends

  //bottom axis graphing
  printf("     ");
  for(int i = 0; i < len; i++)
  {
    temp = i % 5;
    if(temp == 0)
    {
      printf("%-5d", i);
    }
  }//the bottom axis graphing ends
  printf("\n");
}
