#include <stdio.h>

#include "Kernels/AddSleep.cu"


__device__ JobPointer executeJob(volatile JobPointer currentJob);

__global__ void superKernel(volatile Queue incoming, 
                            volatile Queue results, volatile int *kill)
{ 
    // init and result are arrays of integers where result should end up
    // being the result of incrementing all elements of init.
    // They have n elements and are (n+1) long. The should wait for the
    // first element to be set to zero
    int warp_size = 32;

    int threadID = threadIdx.x % warp_size;
    int warpID = threadIdx.x / warp_size;   //added depenency on block

    __shared__ JobPointer currentJobs[32];

    while(!(*kill))
    {
      if(threadID==0)
          FrontAndDequeueJob(incoming, &currentJobs[warpID], kill);
      if(*kill)break;

      volatile JobPointer retval;
      if(threadID<(currentJobs[warpID]->numThreads)) 
          retval = executeJob(currentJobs[warpID]);
      if(*kill)break;

      if(threadID==0) EnqueueResult(retval, results, kill);
    }
}

__device__ JobPointer executeJob(JobPointer currentJob){

  int JobType = currentJob->JobType;

  // large switch
  switch(JobType){
    case 0:
      addSleep(currentJob->params);
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
  }
  return currentJob;
}

