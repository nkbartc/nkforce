#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lcd.h"

// tod_t temp;


// int set_tod_from_secs(int time_of_day_sec, tod_t *tod){
//   if(time_of_day_sec > 86400 || time_of_day_sec < 0){
//     return 1; // If time_of_day_sec is invalid (negative or larger
//               // than the number of seconds in a day) does not tod and returns 1 to
//               // indicate an error.
//   }
//   else if(time_of_day_sec < 43200){
//     if(time_of_day_sec < 3600){
//       tod -> hours = 12;
//       tod -> minutes = time_of_day_sec / 60;
//       tod -> seconds = time_of_day_sec % 60;
//       tod -> ispm = 0;
//       return 0; // returns 0 to indicate success.
//     }
//     else{ //L4
//       tod -> hours = time_of_day_sec / 3600;
//       tod -> minutes = (time_of_day_sec % 3600) / 60;
//       tod -> seconds = (time_of_day_sec % 3600) % 60;
//       tod -> ispm = 0;
//       return 0; // returns 0 to indicate success.
//     }
//   }
//   else{  //L3
//     if(time_of_day_sec >= 43200 && time_of_day_sec < 46800){
//       tod -> hours = 12;
//       tod -> minutes = (time_of_day_sec % 3600) / 60;
//       tod -> seconds = (time_of_day_sec % 3600) % 60;
//       tod -> ispm = 1;
//       return 0; // returns 0 to indicate success.
//     }
//     else if(time_of_day_sec == 86400){ // L5
//       tod -> hours = 12;
//       tod -> minutes = 0;
//       tod -> seconds = 0;
//       tod -> ispm = 0;
//       return 0; // returns 0 to indicate success.
//     }
//     else{ // L6
//       tod -> hours = (time_of_day_sec / 3600) - 12;
//       tod -> minutes = (time_of_day_sec % 3600) / 60;
//       tod -> seconds = (time_of_day_sec % 3600) % 60;
//       tod -> ispm = 1;
//       return 0; // returns 0 to indicate success.
//     }
//   }
// }

// int set_display_bits_from_tod(tod_t tod, int *display){
//   if(tod.hours > 12 || tod.hours < 0 || tod.minutes > 60 || tod.minutes < 0){
//     return 1; // If any fields of tod
//               // are negative or too large (e.g. bigger than 12 for hours, bigger
//               // than 59 for min/sec), no change is made to display and 1 is
//               // returned to indicate an error.
//   }
//   // Create an array of bit masks for each of the digits 0-9.
//   // The 0th element of the array contains a bit mask like 0b0111111 which represents the bits that should be set for a 0 digit,
//   // the 1th element of this array has a mask like 0b0000110 which are the bits to be set for a 1.
//   // There should be ten entries in this array in indices 0-9.
//   int bit_mask[10] = {0b0111111, 0b0000110, 0b1011011, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b0000111, 0b1111111, 0b1101111};
//
//   // mask for blank
//   int bit_blank = 0b0000000;
//
//   int min_ones = bit_mask[tod.minutes % 10];
//   int min_tens = bit_mask[tod.minutes / 10] << 7;
//   int hr_ones  = bit_mask[tod.hours % 10] << 14;
//
//   // make lcd for time larger than 10
//   if(tod.hours >= 10){
//     int hr_tens = bit_mask[1] << 21;
//     if(tod.ispm == 1){
//       int ampm = 0b0010 << 28;
//       *display = ampm | min_ones | min_tens | hr_ones | hr_tens ;
//       return 0; // returns 0 to indicate success.
//     }
//     else{
//       int ampm = 0b0001 << 28;
//       *display = ampm | min_ones | min_tens | hr_ones | hr_tens ;
//       return 0; // returns 0 to indicate success.
//     }
//   }
//
//   // need to take care of when hours is less tan 10, which means there will be a blank at hr_tens
//   else{
//     int hr_tens = bit_blank << 28;
//     if(tod.ispm == 1){
//       int ampm = 0b0010 << 28;
//       *display = ampm | min_ones | min_tens | hr_ones | hr_tens ;
//       return 0; // returns 0 to indicate success.
//     }
//     else{
//       int ampm = 0b0001 << 28;
//       *display = ampm | min_ones | min_tens | hr_ones | hr_tens ;
//       return 0; // returns 0 to indicate success.
//     }
//   }
// }

// Makes use of the set_tod_from_secs() and set_display_bits_from_tod() functions.
// int lcd_update(){
//   if(set_tod_from_secs(TIME_OF_DAY_SEC, &temp) == 1){
//     return 1; // If TIME_OF_DAY_SEC appears to be in error
//               // (to large/small) makes no change to LCD_DISPLAY_PORT and returns 1
//               // to indicate an error.
//   }
//   set_display_bits_from_tod(temp, &LCD_DISPLAY_PORT);
//   return 0; // returns 0 to indicate success.
// }
