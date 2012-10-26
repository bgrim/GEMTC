#include "gemtc.cu"

int main(int argc, char **argv){
  setupGemtc(2560);

  int i;
  for(i=0; i<50; i++){
    int sleepTime = 1000;
    void *ret = run(0, 32, &sleepTime, sizeof(int));
    printf("Finished job with parameter: %d\n", *(int *)ret);
  }
  cleanupGemtc();

  return 0;
}
