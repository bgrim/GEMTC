#include <stdio.h>
#include <math.h>
int test(int a, int b)
{
   printf(">>%d, %d\n", a, b);
   return 0;
}


void* makeVectorAddArgsFloat(int size)
{
   float* mem = (float*)malloc(size);
   float* a1 = mem+1;
   float* b1 = a1+32;
   float* c1 = b1+32;
   for (int idx = 0; idx < 32; ++idx)
   {
      a1[idx] = idx;
      b1[idx] = idx;
      c1[idx] = 0;
   }
   mem[0] = 32;
   return (void*)mem;
}

void* makeVectorAddArgs(int N, int & size)
{
   size = (3*N+1)*sizeof(int);
   int* mem = (int*)malloc(size);
   int* a1 = mem+1;
   int* b1 = a1+N;
   int* c1 = b1+N;
   for (int idx = 0; idx < N; ++idx)
   {
      a1[idx] = idx;
      b1[idx] = idx;
      c1[idx] = 0;
   }
   mem[0] = N;
   return (void*)mem;
}


float *makeMatrixTranspose(int ROW, int& size)
{
  int COLUMN = ROW;

  int a=0, b=0;
  size = (2*ROW*ROW+1)*sizeof(float);
  float *stuff = (float *) malloc(size);
  stuff[0] = ROW;
  float* matrixIn = stuff+1;
  float* matrixOut = matrixIn + ROW*ROW;
  for(a=0; a<ROW;a++)
  {
      for(b=0; b<COLUMN;b++)
      {
         //matrix[b + a * ROW]=((float)rand())/((float) RAND_MAX);
         matrixIn[b + a * ROW]=b;
         matrixOut[b + a * ROW]=0;
      }
  }
  return stuff;
}

float *makeMatrixInverse(int ROW, int& size)
{
    float* stuff = makeMatrixTranspose(ROW, size);
    float* matrixIdent = stuff + 1 + ROW*ROW;
    for (int idx = 0; idx < ROW; ++idx)
    {
        for (int jdx = 0; jdx < ROW; ++jdx)
        {
           if (idx == jdx)
              matrixIdent[idx*ROW+jdx] = 1;
           else
              matrixIdent[idx*ROW+jdx] = 0;
        }
    }
    return stuff;
}


void *makeMatrix(int ROW, int& size)
{
  int COLUMN = ROW;

  int a=0, b=0;
  size = (1+2*ROW*COLUMN)*sizeof(float);
  float *stuff = (float *) malloc(size);
  stuff[0] = ROW;
  for(a=0; a<ROW;a++)
  {
    for(b=0; b<COLUMN;b++)
    {
      stuff[a + b * ROW]=((float)rand())/((float) RAND_MAX);
      stuff[a + b * ROW + ROW * COLUMN] = 0.0;
    }
  }
  return stuff;
}

void* makeMatrixMult(int ROW, int& size)
{
  int COLUMN = ROW;
  int a=0, b=0;
  size = (3*ROW*ROW+1)*sizeof(float);
  float *stuff = (float *) malloc(size);
  float* orig = stuff;
  // first parameter is the matrix size
  *stuff = ROW;
  // increment the pointer by one
   stuff = stuff+1;
  for(a=0; a<ROW;a++)
    {
      for(b=0; b<COLUMN;b++)
      {
         stuff[a + b * ROW]= ((float)rand())/((float) RAND_MAX);
         stuff[a + b * ROW + ROW * COLUMN] = 
                     ((float)rand())/((float) RAND_MAX);
         stuff[a + b * ROW + 2*ROW * COLUMN] = 0.0;
      }
    }
  return orig;
}

void* makeMatrixVectorArgs(int ROWS, int& size)
{
    size = (ROWS*ROWS+2*ROWS+1)*sizeof(int);
    int* param = (int*)malloc(size);
    param[0] = ROWS;
    int* matrix = param+1;
    int* vecA = matrix+ROWS*ROWS;
    int* vecB = vecA+ROWS;
    // idx = row
    for (int idx=0;idx<ROWS;++idx)
    {
        // for each column value, jdx = column
        for (int jdx=0;jdx<ROWS;++jdx)
            matrix[jdx+idx*ROWS]=idx;
        vecA[idx]=idx;
        vecB[idx]=idx;
    }
    return (void*)param;
}
