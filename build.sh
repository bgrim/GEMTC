# Compile the GEMTC framework into a shared library
nvcc -arch=sm_11 -o c_wrappers/libtest.so --shared -Xcompiler -fPIC gemtc.cu
# Compile the gemtc_setup wrapper
gcc -std=c99 -I/usr/local/cuda/include -o gemtc_setup -L. -ltest c_wrappers/gemtc_setup.c
# Compile the gemtc_run wrapper
gcc -std=c99 -I/usr/local/cuda/include -o gemtc_run -L. -ltest c_wrappers/gemtc_run.c
# Compile the gemtc_cleanup wrapper
gcc -std=c99 -I/usr/local/cuda/include -o gemtc_cleanup -L. -ltest cwrappers/gemtc_cleanup.c