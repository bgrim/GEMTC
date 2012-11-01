//extern void setupGemtc(int);
extern void *run(int, int, void*, int);
//extern void cleanupGemtc(void);

#include<stdio.h>

int main(int argc, char **argv){
  // declare the size to be shared by both incoming and outgoing queues on the device
  //  setupGemtc(2560);

  int i;
  for(i=0; i<5; i++){
    int sleepTime = 1000;
    void *ret = run(0, 32, &sleepTime, sizeof(int));
    printf("Finished job with parameter: %d\n", *(int *)ret);
  }
  //cleanupGemtc();

  return 0;
}
