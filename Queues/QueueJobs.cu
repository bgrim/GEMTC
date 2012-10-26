#include <stdlib.h>
#include "QueueHelpers.cu"

////////////////////////////////////////////////////////////
// Constructor and Deconsturctor
////////////////////////////////////////////////////////////

Queue CreateQueue(int MaxElements) {
  Queue Q = (Queue) malloc (sizeof(struct QueueRecord));

  Q->Array = (JobPointer *) gemtcMalloc(sizeof(JobPointer)*MaxElements);

  Q->Capacity = MaxElements;
  Q->Front = 1;
  Q->Rear = 0;
  Q->ReadLock = 0;

  Queue d_Q = (Queue) gemtcMalloc(sizeof(struct QueueRecord));
  cudaSafeMemcpy(d_Q, Q, sizeof(struct QueueRecord), 
                 cudaMemcpyHostToDevice, stream_dataIn, 
                 "Copying initial queue to device");
  free(Q);
  return d_Q;
}

void DisposeQueue(Queue d_Q) {
  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));
  cudaSafeMemcpy(h_Q, d_Q, sizeof(struct QueueRecord), 
                 cudaMemcpyDeviceToHost, stream_dataIn,
                 "DisposeQueue, Copying Queue to get array pointer");
  gemtcFree((void *)h_Q->Array);
  free(h_Q);
  gemtcFree(d_Q);
}

////////////////////////////////////////////////////////////
// Host Functions to Change Queues
////////////////////////////////////////////////////////////

void EnqueueJob(JobPointer h_JobDescription, Queue Q) {
//called by CPU

  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));
  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataIn,
                 "EnqueueJob, Getting Queue");

  while(h_IsFull(h_Q)){
    pthread_yield();
    cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataIn,
                    "EnqueueJob, Getting Queue again...");
  }

  // floating point exception from mod capacity if 0 or -n
  h_Q->Rear = (h_Q->Rear+1)%(h_Q->Capacity);

  JobPointer d_JobDescription = 
      (JobPointer) gemtcMalloc(sizeof(struct JobDescription));

  cudaSafeMemcpy( d_JobDescription,
                  h_JobDescription, 
                  sizeof(struct JobDescription),
                  cudaMemcpyHostToDevice, 
                  stream_dataIn,
                  "EnqueueJob, Writing JobDescription");

  // set job description
  cudaSafeMemcpy( (void *)&h_Q->Array[h_Q->Rear],
                  &d_JobDescription, 
                  sizeof(JobPointer),
                  cudaMemcpyHostToDevice, 
                  stream_dataIn,
                  "EnqueueJob, Writing JobPointer");

  cudaSafeMemcpy(movePointer(Q, 12), movePointer(h_Q, 12), 
		 sizeof(int), cudaMemcpyHostToDevice, stream_dataIn,
                 "EnqueueJob, Updating Queue");
  free(h_Q);
}

JobPointer FrontResult(Queue Q) {
//called by CPU
  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));

  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting Queue");
  while(h_IsEmpty(h_Q)){
    pthread_yield();
    cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                   "FandDJob, Getting Queue again...");
  }
  JobPointer *resultP = (JobPointer *) malloc(sizeof(JobPointer));
  JobPointer result = (JobPointer) malloc(sizeof(struct JobDescription));

  cudaSafeMemcpy(resultP, (void *)&h_Q->Array[h_Q->Front], sizeof(JobPointer), 
                 cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting JobPointer");

  cudaSafeMemcpy(result, (void *)*resultP, sizeof(struct JobDescription), 
                 cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting JobDescription");

  free(h_Q);
  gemtcFree(*resultP);
  free(resultP);

  return result;
}
void DequeueResult(Queue Q) {
//called by CPU
  int copySize= sizeof(struct QueueRecord);

  Queue h_Q = (Queue) malloc(sizeof(struct QueueRecord));

  cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                 "FandDJob, Getting Queue");

  while(h_IsEmpty(h_Q)){
    pthread_yield();
    cudaSafeMemcpy(h_Q, Q, copySize, cudaMemcpyDeviceToHost, stream_dataOut,
                   "FandDJob, Getting Queue again...");
  }

  h_Q->Front = (h_Q->Front+1)%(h_Q->Capacity);

  cudaSafeMemcpy( movePointer(Q, 16), movePointer(h_Q, 16), 
		  sizeof(int), cudaMemcpyHostToDevice, stream_dataOut,
                  "FandDJob, Updating Queue");

  free(h_Q);
}


////////////////////////////////////////////////////////////
// Device Functions to Change Queues
////////////////////////////////////////////////////////////
__device__ void FrontAndDequeueJob(volatile Queue Q, volatile JobPointer *pResult, 
                                   volatile int *kill) {
//called by GPU
  getLock(Q);

  int count = 0;
  while(d_IsEmpty(Q)){
    if(*kill)return;
    count++;
  }
  volatile int *front = &Q->Front;

  volatile JobPointer *ppResult = Q->Array + *front;

  *pResult = *ppResult;

  *front = (*front+1)%(Q->Capacity);

  releaseLock(Q);
}

__device__ void EnqueueResult(volatile JobPointer X, volatile Queue Q, volatile int *kill) {
//called by GPU
  getLock(Q);

  int count =0;
  while(d_IsFull(Q)){
    count++;
    if(*kill)return;
  }
  volatile int *rear = &Q->Rear;
  int temp = (*rear + 1)%(Q->Capacity);

  volatile JobPointer *pLoc = Q->Array + temp;
  *pLoc = X;

  *rear = temp;

  releaseLock(Q);
}




