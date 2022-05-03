#include <stdio.h>
#include <stdlib.h>

__global__
void helloKernel(int N)
{
  printf("hello from GPU\n");
  int i = threadIdx.x + blockIdx.x*blockDim.x;
  if (i<N) {
    printf("thread %d of block %d (dim: %d): iter %d of %d\n", threadIdx.x, blockIdx.x, blockDim.x, i, N);
  }
}

int main(void) {
  int N=10,numGPUs;

  /* check have GPU else quit */
  cudaGetDeviceCount(&numGPUs);
  printf("Number of  GPU = %d\n", numGPUs);
  if (numGPUs >= 1 ) {
  printf("hello on CPU\n");

  /* call GPU kernel  */
  helloKernel<<<4,3>>> (N);

  /* Synchronize */
  cudaDeviceSynchronize();

  printf("hello again from CPU\n");
  
  }
  else {
   printf("no GPU present\n");
   }
}


