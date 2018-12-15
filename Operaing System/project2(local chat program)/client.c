/*CSci4061 F2018 Assignment 2
section: 10
date:  11/10/18
*name:  Jake Johnson, Ren Jeik,Ju-Yu Chou Fu
*id: 5160192,5343975,5411243
*/
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/un.h>
#include <sys/wait.h>
#include <sys/socket.h>
#include "comm.h"
#include <signal.h>

#define BUF_SIZE 50
// i may need this dont edit it
// void sighandler(int);

/* -------------------------Main function for the client ----------------------*/
void main(int argc, char * argv[]) {

	int pipe_user_reading_from_server[2], pipe_user_writing_to_server[2];

	// You will need to get user name as a parameter, argv[1].

	if(connect_to_server("ggininder", argv[1], pipe_user_reading_from_server, pipe_user_writing_to_server) == -1) {
		exit(-1);
	}

	/* -------------- YOUR CODE STARTS HERE -----------------------------------*/
	fcntl(0, F_SETFL, fcntl(0, F_GETFL)| O_NONBLOCK);
	int flag1 = fcntl(pipe_user_writing_to_server[1], F_GETFL, 0);
	int flag2 = fcntl(pipe_user_reading_from_server[0], F_GETFL, 0);
	fcntl(pipe_user_writing_to_server[1], F_SETFL, flag1 | O_NONBLOCK);
	fcntl(pipe_user_reading_from_server[0], F_SETFL, flag2 | O_NONBLOCK);
	close(pipe_user_writing_to_server[0]);
	close(pipe_user_reading_from_server[1]);

	while(1){
		char buffer1[BUF_SIZE], buffer2[BUF_SIZE];
		int i, j;
		char bye[] = "You have been kicked by the admin.";
		// user reads stdin
		if((i = read(0, buffer1, BUF_SIZE)) > 0){
			if(i == 1){ //handle empty input and avoid segmentation fault
        continue;
      }
			buffer1[i-1] = '\0';
			write(pipe_user_writing_to_server[1], buffer1, i);
		}
		if((j = read(pipe_user_reading_from_server[0], buffer2, BUF_SIZE)) > 0){
			printf("%s\n", buffer2);

			if(strcmp(bye, buffer2) == 0){
				close(pipe_user_writing_to_server[1]);
				close(pipe_user_reading_from_server[0]);
				exit(1);
			}
		}
		usleep(5000);
	}
	// poll pipe retrieved and print it to sdiout

	// Poll stdin (input from the terminal) and send it to server (child process) via pipe


	/* -------------- YOUR CODE ENDS HERE -----------------------------------*/
}

// i may need this dont edit it
// void sighandler(int signum) {
//    printf("got signal %d\n", signum);
//    exit(1);
// }

/*--------------------------End of main for the client --------------------------*/
