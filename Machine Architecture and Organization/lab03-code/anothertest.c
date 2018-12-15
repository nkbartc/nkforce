int main (void){
  FILE *fin = fopen("here","r");
     char buf[100];             // store up to 100 characters
     int pos = 0;
     while(1){
       int result = fscanf(fin, "%d", &buf[pos]);
       if(result == EOF){
         break;
     }
    pos++;
  }
}
