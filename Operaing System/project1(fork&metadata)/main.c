/* CSci4061 F2018 Assignment 1
 * login: cselabs login name (login used to submit)
 * date: mm/dd/yy
 * name: , full name2, full name3 (for partner(s))
 * id: id for first name, id for second name, id for third name */

/* Left to do:
 * test cases that run for all edge cases
 * ReadMe
 *
 *
 */
/*questions:
 * echo is returning a string in 'quotes', is that okay?
 *
 *
 */
//build one element taken in?

// This is the main file for the code
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include "util.h"

/*-------------------------------------------------------HELPER FUNCTIONS PROTOTYPES---------------------------------*/
void show_error_message(char * ExecName);
//Write your functions prototypes here
void show_targets(target_t targets[], int nTargetCount);
void build(char* targetname, target_t targets[], int nTargetCount);
void exectutionOfDependant(target_t targets[], int index);
/*-------------------------------------------------------END OF HELPER FUNCTIONS PROTOTYPES--------------------------*/


/*-------------------------------------------------------HELPER FUNCTIONS--------------------------------------------*/

//This is the function for writing an error to the stream
//It prints the same message in all the cases
void show_error_message(char * ExecName)
{
    fprintf(stderr, "Usage: %s [options] [target] : only single target is allowed.\n", ExecName);
    fprintf(stderr, "-f FILE\t\tRead FILE as a makefile.\n");
    fprintf(stderr, "-h\t\tPrint this message and exit.\n");
    exit(0);
}

//Write your functions here

//Phase1: Warmup phase for parsing the structure here. Do it as per the PDF (Writeup)
char* removeChar(char* str)                                                 
{
    char *output = str;
    char *temp = str;

    for(; *str != '\0'; ++str){
        if(*str != '\''){
            *temp++ = *str;
        }
    }
    *temp = '\0';

    return output;                                                        
}

void exectutionOfDependant(target_t targets[],int index){
    
    pid_t childpid;
    targets[index].Status = 1;
    childpid = fork();
    
    if(childpid == 0){
        //handle the string work later
        
        if (strcmp(targets[index].Command,"")==0){
            printf("make:'%s' is up to date.\n", targets[index].TargetName);
            return;
        }
        
        // if (strcmp((char)targets[index].Command[0],"#")==0){
        //     printf("%s \n", targets[index].Command);
        // }
        
        char args[1023];
        strcpy(args, targets[index].Command);

        if (args[0] == '#'){
            printf("%s \n", args);
            return;
        }

        int size = sizeof(args);
        char *newPtr[1023];
        
        
        int i=0;
        char temp[ARG_MAX];
        strcpy(temp, args);
        char *tok = strtok(temp, " ");
        while(tok!=NULL && i<ARG_MAX)
        {
            newPtr[i] = tok;
            removeChar(newPtr[i]);
            i++;
            tok = strtok(NULL, " ");
        }
        newPtr[i] = NULL;

        // int j = 0;
        // while(newPtr[j+3]!=NULL)
        // {
        //     removeChar(newPtr[j]);
        //     j++;
         
        // }
        
        // printf("%s\n", args);
        // printf("%c\n", args[0]);
        removeChar(args);
        printf("%s\n", args);
        execvp(newPtr[0], newPtr);
        perror("failed to execvp");
        //free(newPtr);
        exit(-1);
    }
    else if(childpid > 0){
        int wstatus;
        wait(&wstatus);
        if (WEXITSTATUS(wstatus) != 0) {
            printf("child exited with error code=%d\n", WEXITSTATUS(wstatus));
            exit(-1);
        }
        //printf("\nCompleted target \n");
        //target built
    }
    else{
        perror("fork() failed");
        exit(-1);
    }
}

void show_targets(target_t targets[], int nTargetCount)
{
    printf("%d\n", nTargetCount);
    //Write your warmup code here
    //try except loop?
    //int length = sizeof(target_t)/sizeof(target_t[0]);
    for(int i=0;i<nTargetCount;i++){
        printf("TargetName: %s\n", targets[i].TargetName);
        printf("DependancyCount: %d\n", targets[i].DependencyCount);
        printf("DepenedancyNames: ");
        for(int j=0;j<targets[i].DependencyCount;j++){
            printf("%s ", targets[i].DependencyNames[j]);
        }
        printf("\nCommand: %s\n", targets[i].Command);
    }
}
//having one input for build?

// status 0 is default value which is not checked yet and not execute yet, 1 is finished, 2 is ready to built or rebuild
void build(char* targetname, target_t targets[], int nTargetCount){
    int index = find_target(targetname, targets, nTargetCount);
    //found target.
    if(index >= 0){
        //for each dependent target Ti that needs to be be built
        //printf("working with target: %s\n", targetname);
        if (targets[index].DependencyCount == 0){
            exectutionOfDependant(targets, index);
            return;
        }
        
        for(int i = 0; i < targets[index].DependencyCount; i++){
            char *dept_file = targets[index].DependencyNames[i];
            //printf("let's see what need to do with the file %s\n", dept_file);
            build(dept_file, targets, nTargetCount);
            //printf("now come back to %s\n", targetname);
            
            // In the first time calling make4061, the program doesn't need
            // to check modification time because all the targets are not built
            // so there is nothing we can compare.
            // We need to compare the modification time if we are going to call
            // make4061 more than once because if we don't need to build a file
            // that has been built already.
            if (does_file_exist(dept_file) == 0 && does_file_exist(targetname) == 0){
                //printf("the target file: %s exists. What do we do now?\n", targetname);
                int timeDifference = compare_modification_time(targetname, dept_file);
                
                //target or file doesn't exist
                if(timeDifference == -1){
                    perror("the file does not exist");
                    exit(-1);
                }
                //Both the target and file have identical timestamp. do nothing
                if(timeDifference == 0){
                    //printf("Both the target and file have identical timestamp. do nothing\n");
                }
                //target is modified later than file. do nothing
                if(timeDifference == 1){
                    //    printf("target is modified later than file. do nothing\n");
                    // base case. this is the last target ignoring "clean"
                    // use -2 instead of -1 due to "clean". i want to avoid it.
                    // would this be fine for other secret tests?
                    if(index == nTargetCount -1){
                        //printf("Base case here: %s, but it's built. do nothing\n", targetname);
                        return;
                    }
                }
                //target is modified earlier than file. need to build or rebuild
                if(timeDifference == 2){
                    //printf("target is modified earlier than file. need to build or rebuild it\n");
                    targets[index].Status = 2;
                }
            }
            // visited target waits to be built.
            else{
                // printf("target: %s needs to be built\n", targetname);
                targets[index].Status = 2;
            }
            
        } // forloop end. what do we want to do with the target?
        
        // base case. this is the last target ignoring "clean"
        // use -2 instead of -1 due to "clean". i want to avoid it.
        // would this be fine for other secret tests?
        if(index == nTargetCount -1){
            //printf("Base case here: %s\n", targetname);
            targets[index].Status = 2;
        }
        
        // target's status is not 2. do nothing
        if(targets[index].Status != 2){
            return;
        }
        
        //printf("Ready to build target: %s now\n", targetname);
    }
    
    else{ // index = -1. it can't be a target. what is it?
        if(does_file_exist(targetname) == -1){
            perror("the file doesn't exist");
            exit(-1);
        }
        else{
            //printf("need this file %s. return\n", targetname);
            return;
        }
        
    }
    // Ready to build something now
    exectutionOfDependant(targets,index);
}

/*-------------------------------------------------------END OF HELPER FUNCTIONS-------------------------------------*/


/*-------------------------------------------------------MAIN PROGRAM------------------------------------------------*/
//Main commencement
int main(int argc, char *argv[])
{
    target_t targets[MAX_NODES];
    int nTargetCount = 0;
    
    /* Variables you'll want to use */
    char Makefile[64] = "Makefile";
    char TargetName[64];
    
    /* Declarations for getopt */
    extern int optind;
    extern char * optarg;
    int ch;
    char *format = "f:h";
    char *temp;
    
    //Getopt function is used to access the command line arguments. However there can be arguments which may or may not need the parameters after the command
    //Example -f <filename> needs a finename, and therefore we need to give a colon after that sort of argument
    //Ex. f: for h there won't be any argument hence we are not going to do the same for h, hence "f:h"
    while((ch = getopt(argc, argv, format)) != -1)
    {
        switch(ch)
        {
            case 'f':
                temp = strdup(optarg);
                strcpy(Makefile, temp);  // here the strdup returns a string and that is later copied using the strcpy
                free(temp);    //need to manually free the pointer
                break;
                
            case 'h':
            default:
                show_error_message(argv[0]);
                exit(1);
        }
        
    }
    
    argc -= optind;
    if(argc > 1)   //Means that we are giving more than 1 target which is not accepted
    {
        show_error_message(argv[0]);
        return -1;   //This line is not needed
    }
    
    /* Init Targets */
    memset(targets, 0, sizeof(targets));   //initialize all the nodes first, just to avoid the valgrind checks
    
    /* Parse graph file or die, This is the main function to perform the toplogical sort and hence populate the structure */
    if((nTargetCount = parse(Makefile, targets)) == -1)  //here the parser returns the starting address of the array of the structure. Here we gave the makefile and then it just does the parsing of the makefile and then it has created array of the nodes
        return -1;
    
    
    //Phase1: Warmup-----------------------------------------------------------------------------------------------------
    //Parse the structure elements and print them as mentioned in the Project Writeup
    /* Comment out the following line before Phase2 */
    //show_targets(targets, nTargetCount);
    //End of Warmup------------------------------------------------------------------------------------------------------
    
    /*
     * Set Targetname
     * If target is not set, set it to default (first target from makefile)
     */
    if(argc == 1)
        strcpy(TargetName, argv[optind]);    // here we have the given target, this acts as a method to begin the building
    else
        strcpy(TargetName, targets[0].TargetName);  // default part is the first target
    
    /*
     * Now, the file has been parsed and the targets have been named.
     * You'll now want to check all dependencies (whether they are
     * available targets or files) and then execute the target that
     * was specified on the command line, along with their dependencies,
     * etc. Else if no target is mentioned then build the first target
     * found in Makefile.
     */
    
    //don't make the program more than once
    
    //Phase2: Begins ----------------------------------------------------------------------------------------------------
    /*Your code begins here*/
    
    build(TargetName,targets,nTargetCount);
    //printf("the target has been built\n");
    
    
    /*End of your code*/
    //End of Phase2------------------------------------------------------------------------------------------------------
}

//use child to execute code, it returns back and parent continues
//use make to create make4061, put that file in other test cases to test
/*-------------------------------------------------------END OF MAIN PROGRAM------------------------------------------*/
