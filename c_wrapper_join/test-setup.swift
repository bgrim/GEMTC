
#include <builtins.swift>
#include "setup.swift"
#include <io.swift>
#include <sys.swift>

main {
float x = c_setup(0);
	       wait (x) {
    	       	    printf("Working 1");
		    }
float y = c_run(0);
	       wait (y) {
    	       	    printf("Working 2");
		    }
}
