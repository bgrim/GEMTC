
#include <builtins.swift>
#include "sleep1.swift"
#include <io.swift>
#include <sys.swift>

main {

//     int bound = toint(argv("bound"));
//     float sleepTime = tofloat(argv("sleeptime"));

 // run the sleep
     foreach i in [1:1:1]{
               float y = c_sleep(0);
	       wait (y) {
    	       	    printf("Working");
		    }
	}
}
