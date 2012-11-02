extern void setupGemtc(int);

#include<stdio.h>

int main(){
  setup();
  printf("setup complete.\n");
  return 0;
}

int setup(){
  setupGemtc(2560);
  return 0;
}
