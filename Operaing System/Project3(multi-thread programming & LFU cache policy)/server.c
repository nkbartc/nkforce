#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <sys/time.h>
#include <time.h>
#include "util.h"
#include <stdbool.h>
#include <unistd.h>
#include <limits.h>
#include <signal.h>


#define MAX_THREADS 100
#define MAX_QUEUE_LEN 100
#define MAX_CE 100
#define INVALID -1
#define OK 0
#define BUFF_SIZE 1024

/*
  THE CODE STRUCTURE GIVEN BELOW IS JUST A SUGESSTION. FEEL FREE TO MODIFY AS NEEDED
*/

// structs:
typedef struct request_queue {
   int fd;
   char request[BUFF_SIZE];
} request_t;

typedef struct cache_entry {
    unsigned long len;
    char *request; //name of the file
    char *content; //content of the file
    int count;
} cache_entry_t;

//globals

// declare the mutex lock
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
// web log write lock
pthread_mutex_t wlock = PTHREAD_MUTEX_INITIALIZER;
// worker: wait for new tasks
pthread_cond_t some_tasks = PTHREAD_COND_INITIALIZER;
// dispatcher: wait fora free slot
pthread_cond_t free_slot = PTHREAD_COND_INITIALIZER;
// the request_queue
struct request_queue buffer[MAX_QUEUE_LEN];
// buffer counter
int next_index = -1;
//  total number of requests a specific worker thread has handled so far
int reqNum;
// web_server_log
FILE *res_log;
//End threads
int self_destruct = 1;
//End main
int run = 1;
//total cache size
int cache_size;
// a global cache
struct cache_entry *cache;


/* ************************ Dynamic Pool Code ***********************************/
// Extra Credit: This function implements the policy to change the worker thread pool dynamically
// depending on the number of requests
void * dynamic_pool_size_update(void *arg) {
  while(1) {
    // Run at regular intervals
    // Increase / decrease dynamically based on your policy
  }
}
/**********************************************************************************/

/* ************************************ Cache Code ********************************/

// getCacheIndex simply uses a linear search to match the request name and reutrn the place.

// Function to check whether the given request is present in cache
int getCacheIndex(char *request, int size) {   //added a size paramenter to keep track of cache array size.
  /// return the index if the request is present in the cache

  bool found = false;
  int x = 0;
  while (found == false && x < size) {
	  // see if request is NULL, because dangerous to do strcmp with NULL
     if (cache[x].request != NULL && !strcmp(cache[x].request, request)) {
        found = true;
     }
     else {
        x++;
     }
  }
  if (found == false) {
     return INVALID;    // have it return INVALID if it isn't found.
  }
  else {
     return x;
  }
}

// addIntoCache Uses a LFU cache policy to add new entries.

// Function to add the request and its file content into the cache
void addIntoCache(char *mybuf, char *memory , unsigned long memory_size, int cache_size) {
  int i;
  int freq = cache[0].count; //0 on init
  int target = 0;
  // find the cache with the least frequency
  for(i = 0; i < cache_size; i++) {
    if(cache[i].request == NULL) {
      cache[i].count = 1; //set cache entry frequency
      cache[i].len = memory_size; // set size of file
      cache[i].request = malloc((strlen(mybuf) + 1) * sizeof(char));
      if (cache[i].request == NULL) {
          perror("Error ");
          exit(1);
      }
      strcpy(cache[i].request, mybuf); // put file name
      cache[i].content = (char *)malloc(memory_size);
      if (cache[i].content == NULL) {
          perror("Error ");
          exit(1);
      }
      memcpy(cache[i].content, memory, memory_size); // copy bytes
      return;
    }
    else if(cache[i].count < freq) {
      freq = cache[i].count;
      target = i;
    }
  }
  if(cache[target].request != NULL) {
    free(cache[target].request);
    free(cache[target].content);
  }
  cache[target].count = 1;
  cache[target].len = memory_size;
  cache[target].request = malloc((strlen(mybuf) + 1) * sizeof(char));
  if (cache[target].request == NULL) {
      perror("Error ");
      exit(1);
  }
  strcpy(cache[target].request, mybuf);
  cache[target].content = (char *)malloc(memory_size);
  if (cache[target].content == NULL) {
      perror("Error ");
      exit(1);
  }
  memcpy(cache[target].content, memory, memory_size);
  return;
}

// clear the memory allocated to the cache
void deleteCache(int size) {
    for(int x = 0; x < size; x++) {
     cache[x].len = 0;
     if(cache[x].request != NULL) {
     free(cache[x].request);
 }
	 if(cache[x].content != NULL) {
     free(cache[x].content);
 }
     cache[x].count = 0;
 }
}

// initCache takes in a number of cache entries and creates an array of entry pointers

// Function to initialize the cache
void initCache(int size) {

  /* Allocates memory with malloc, and then goes through the cache array and
  initializes each property to 0 and NULL. Returns the cache so it may be used.*/

  cache = malloc(size * sizeof(cache_entry_t));
  if (cache == NULL) {
      perror("Error ");
      exit(1);
  }
  for(int x = 0; x < size; x++) {
     cache[x].len = 0;
     cache[x].request = NULL;
     cache[x].content = NULL;
     cache[x].count = 0;
 }

}

// copies cache entry to binary buffer
int getFromCache(char * name, char ** fbin, int index, unsigned long * length) {
		*length = cache[index].len;                      //store length for printing, could be removed in final submission
		*fbin = (char *)malloc(*length);                 // make enough space to hold cache entry
      if (fbin == NULL) {
          perror("Error ");
          return INVALID;
      }
		memcpy(*fbin, cache[index].content, *length);    // copy from cache
}


// readFromDisk opens a file name and puts the binary into fbin. If the file cannont be opened it returns -1.

// Function to open and read the file from the disk into the memory
// Add necessary arguments as needed
int readFromDisk(char * name, char ** fbin, unsigned long * length) {
  char fpath[PATH_MAX];
  getcwd(fpath, PATH_MAX);       // eventually needs to be fixed to figure out relative path??
  strcat(fpath, name);
  FILE* data;
  data = fopen(fpath, "rb");
  if(!data)
  {
	  // fix bad read error
	  *length = INVALID;
	  return INVALID;
  }
  else {
  struct stat st;
  if(stat(fpath, &st))
	return INVALID;
  *length = (long) st.st_size;

  *fbin = (char *)malloc(*length);
  if (fbin == NULL) {
      perror("Error ");
      return INVALID;
  }
  size_t readf = 0;
  fread(*fbin, *length, sizeof(unsigned char), data);
  fclose(data);
}
  return 0;
}

/**********************************************************************************/

/* ************************************ Utilities ********************************/

//getContentType determines file type by extension name

// Function to get the content type from the request
char* getContentType(char * mybuf) {
  // Should return the content type based on the file type in the request
  int i;                // i is used to track the corresponding content type
  int found = 0;        // flag for strstr checking. 0: not found; 1: found matched content-type
  char result[20];
  char* possible_types[] = {".html", ".htm", ".jpg", ".gif"};
  char* content_types[]  = {"text/html", "text/html", "image/jpeg", "image/gif", "text/plain"};
  for(i = 0; i < 4; i++) {
    if(strstr(mybuf, possible_types[i])) {
      found = 1;
      mybuf[0] = '\0';
      strcpy(mybuf, content_types[i]);
      break;
    }
  }
  if(!found) {
    mybuf[0] = '\0';
    strcpy(mybuf, content_types[4]);
  }
}

// This function returns the current time in microseconds
long getCurrentTimeInMicro() {
  struct timeval curr_time;
  gettimeofday(&curr_time, NULL);
  return curr_time.tv_sec * 1000000 + curr_time.tv_usec;
}

/**********************************************************************************/

// dispatch is used by dispatcher threads to take in requests and place them into the request queue

// Function to receive the request from the client and add to the queue
void * dispatch(void *arg) {
  char buf[BUFF_SIZE];
  while (self_destruct) {
     // Accept client connection
     int fd = accept_connection();
     if(fd < 0) {
      //if the return value is negative, the request should be ignored.
      continue;
     }
     // Get request from the client
	   if((get_request(fd, buf)) != 0) {
       //returns 0 on success, nonzero on failure. You must account
       //for failures because some connections might send faulty
       //requests.
       return_error(fd, buf);
       continue;
     }
     // Add the request into the queue
     pthread_mutex_lock(&lock);
     if(next_index == MAX_QUEUE_LEN) {
       pthread_cond_wait(&free_slot, &lock);
     }
     next_index++;
     buffer[next_index].fd = fd;
     strcpy(buffer[next_index].request, buf);
     pthread_cond_signal(&some_tasks);
     pthread_mutex_unlock(&lock);
	}
}

/**********************************************************************************/

// worker is used by worker threads to take requests from request queue and return them to the client.
// It also logs requests in the web server log.

// Function to retrieve the request from the queue, process it and then return a result to the client
void * worker(void *i) {
  int check = OK;
  int threadId = *((int *) i);
  int reqNum =  0;
  char request_string[BUFF_SIZE];
  char the_type[BUFF_SIZE];
   while (self_destruct) {
    // Get the request from the queue
    pthread_mutex_lock(&lock);
    while(next_index < 0) {
      pthread_cond_wait(&some_tasks, &lock);
    }
    // Start recording time
    long begin = getCurrentTimeInMicro();
    int fd = buffer[next_index].fd;
    strcpy(request_string, buffer[next_index].request);
    next_index--;

    pthread_cond_signal(&free_slot);

    // Get the data from the disk or the cache

	  int ret;
    unsigned long length = INVALID;
    char * fbin;
    int index = getCacheIndex(request_string, cache_size);
    if(index == INVALID) {
		  ret = readFromDisk(request_string, &fbin, &length);
		  if(ret == INVALID) {
         char * err = "File does not exist";
         check = fprintf(res_log, "[%d][%d][%d][%s][%s][%li us][%s]\r\n", threadId, reqNum, fd, request_string, "File does not exist", (long int)time, "MISS");
         if (check < OK) {
           perror("Error ");
           exit(1);
         }
         check = printf("[%d][%d][%d][%s][%s][%li us][%s]\r\n", threadId, reqNum, fd, request_string, "File does not exist", (long int)time, "MISS");
         if (check < OK) {
           perror("Error ");
           exit(1);
         }
         return_error(fd, err);
         pthread_mutex_unlock(&lock);
		     continue;
		     }
	     addIntoCache(request_string, fbin, length, cache_size);
	  }
	  else {
		    getFromCache(request_string, &fbin, index, &length);
	  }
	  pthread_mutex_unlock(&lock);
    strcpy(the_type, request_string);
    getContentType(the_type);
    return_result(fd, the_type , fbin, length);
    reqNum++;
    free(fbin);
    // Stop recording the time
    long end = getCurrentTimeInMicro();
    // Log the request into the file and terminal
    long time = end - begin;
    pthread_mutex_lock(&wlock);
    if(index == INVALID) {
      check = fprintf(res_log, "[%d][%d][%d][%s][%ld][%luus][%s]\r\n", threadId, reqNum, fd, request_string, length, time, "MISS");
      if (check < OK) {
        perror("Error ");
        exit(1);
      }
      check = printf("[%d][%d][%d][%s][%ld][%luus][%s]\r\n", threadId, reqNum, fd, request_string, length, time, "MISS");
      if (check < OK) {
        perror("Error ");
        exit(1);
      }
    }
    else {
      check = fprintf(res_log, "[%d][%d][%d][%s][%ld][%luus][%s]\r\n", threadId, reqNum, fd, request_string, length, time, "HIT");
      if (check < OK) {
        perror("Error ");
        exit(1);
      }
      check = printf("[%d][%d][%d][%s][%ld][%luus][%s]\r\n", threadId, reqNum, fd, request_string, length, time, "HIT");
      if (check < OK) {
        perror("Error ");
        exit(1);
      }
    }
    pthread_mutex_unlock(&wlock);
  }
}

// makes worker threads

void createWorkers(pthread_t * worker_ids, int num_workers) {
   int check = OK;
	while(num_workers > 0) {
		num_workers--;
    int *ID = malloc(sizeof(*ID));
    if (ID == NULL)
    {
      check = fprintf(stderr, "Error adding thread %i\n", num_workers);
      if (check < OK) {
        perror("Error ");
        exit(1);
      }
      exit(1);
    }
    *ID = num_workers;
    int check1 = pthread_create(&worker_ids[num_workers], NULL, worker, ID);
		int check2 = pthread_detach(worker_ids[num_workers]);
      if (check1 != OK || check2 != OK) {
         check = fprintf(stderr, "Thread error.\n");
         if (check < OK) {
           perror("Error ");
           exit(1);
         }
      }
	}
}

// makes dispatcher threads

void createDispatchers(pthread_t * dispatcher_ids, int num_dispatchers) {
   int check = OK;
	while(num_dispatchers > 0) {
		num_dispatchers--;
    int check1 = pthread_create(&dispatcher_ids[num_dispatchers], NULL, dispatch, NULL);
	  int check2 = pthread_detach(dispatcher_ids[num_dispatchers]);
      if (check1 != OK || check2 != OK) {
         check = fprintf(stderr, "Thread error.\n");
         if (check < OK) {
           perror("Error ");
           exit(1);
         }
      }
	}
}

// joins worker threads

void cleanupWorkers(pthread_t * worker_ids, int total) {
	for(int i = 0; i < total; i++) {
		pthread_join(worker_ids[i], NULL);
	}
}

// joins dispatcher threads

void cleanupDispatchers(pthread_t * dispatcher_ids, int total) {
	for(int i = 0; i < total; i++) {
		pthread_join(dispatcher_ids[i], NULL);
	}
}

/**********************************************************************************/

// main initializes server processes and handles closing procedures

int main(int argc, char **argv) {
	sigset_t set;
	sigemptyset(&set);
	sigaddset(&set, SIGINT);
	sigprocmask(SIG_BLOCK, &set, NULL);
	int sig;
	int *sigptr = &sig;
	int ret;
  // open server log file
  res_log = fopen("web_server_log.txt", "a");
  // Error check on number of arguments
  if(argc != 8) {
    printf("usage: %s port path num_dispatcher num_workers dynamic_flag queue_length cache_size\n", argv[0]);
    return INVALID;
  }

   int port = atoi(argv[1]);
	const char* path = argv[2];
	int num_dispatchers = atoi(argv[3]);
	int num_workers = atoi(argv[4]);
	int dynamic_flag = atoi(argv[5]);
	int qlen = atoi(argv[6]);
	int cache_entries = atoi(argv[7]);
  // Perform error checks on the input arguments
  //Checks port number to be between 1025 - 65535
  if (port < 1025 || port > 65535) {
     return INVALID;
  }
  //Check path
  int check = atoi(path);
  if (check != OK) {  //The argument given for path was not a string path.
     return INVALID;
  }
  //Checks num_dispatcher
  if (num_dispatchers < 1 || num_dispatchers > MAX_THREADS) {
    printf("Number of dispatchers must be between 1 and %i\n", MAX_THREADS);
     return INVALID;
  }
  //Checks num_workers
  if (num_workers < 1 || num_workers > MAX_THREADS) {
    printf("Number of workers must be between 1 and %i\n", MAX_THREADS);
     return INVALID;
  }
  //Checks dynamic_flag... default to 0?
  dynamic_flag = 0;

  //Checks qlen
  if (qlen < 1 || qlen > MAX_QUEUE_LEN) {
    printf("Request queue length must be between 1 and %i\n", MAX_QUEUE_LEN);
     return INVALID;
  }
  //Checks cache_entries
  if (cache_entries < 1 || cache_entries > MAX_CE) {
    printf("Number of cache entries must be between 1 and %i\n", MAX_CE);
     return INVALID;
  }
  // Change the current working directory to server root directory
  int pcheck = chdir(path);
  if(pcheck == INVALID) {
    printf("Path is not valid: %s\n", path);
    return INVALID;
  }
  char cwd[PATH_MAX];
  if (getcwd(cwd, sizeof(cwd)) != NULL) {
	printf("Current working dir: %s\n", cwd);
  }
  // Start the server and initialize cache
  init(port);
  cache_size = cache_entries;
  initCache(cache_size);
  // Create dispatcher and worker threads
	pthread_t dispatcher_ids[num_dispatchers];
	pthread_t worker_ids[num_workers];
	createDispatchers(dispatcher_ids, num_dispatchers);
	createWorkers(worker_ids, num_workers);
  // Clean up
	ret = sigwait(&set, sigptr);
  //if sigwait it used then do all cleanup stuff here
  printf("\nClosing threads\n");
  cleanupDispatchers(dispatcher_ids, num_dispatchers);
  cleanupWorkers(worker_ids, num_workers);
  // terminates all thread while loops
  self_destruct = 0;
  // close server log
  printf("Closing and saving server log\n");
  fclose(res_log);
  printf("Clearing cache\n");
  deleteCache(cache_entries);
  return 0;
}
