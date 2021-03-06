
# generated by stc
# date: 2012/10/19 14:46:38

package require turbine 0.0.6
namespace import turbine::*


proc swift:constants {  } {
    turbine::c::log "function:swift:constants"
    global c:s_bye
    turbine::allocate c:s_bye string
    turbine::store_string ${c:s_bye} "bye"
    global c:s_hello
    turbine::allocate c:s_hello string
    turbine::store_string ${c:s_hello} "hello"
}

package require synth1 0.0.1


proc swift:main {  } {
    turbine::c::log "enter function: main"
    set stack 0
    turbine::allocate u:o string
    global c:s_bye
    global c:s_hello
    # Swift l.6: assigning expression to s1
    # Swift l.7: assigning expression to s2
    # Swift l.9: assigning expression to o
    synth1::c_strcat ${stack} [ list ${u:o} ] [ list ${c:s_hello} ${c:s_bye} ]
    # Swift l.11 evaluating  expression and throwing away 0 results
    turbine::c::rule main-optinserted [ list ${u:o} ] ${turbine::LOCAL} [ list main-optinserted ${stack} ${u:o} ]
}


proc main-optinserted { stack u:o } {
    # Value __ov_o-0 with type $string was defined
    set optv:o-0 [ turbine::retrieve_string ${u:o} ]
    turbine::trace_impl ${optv:o-0}
}

turbine::defaults
turbine::init $engines $servers
turbine::start swift:main swift:constants
turbine::finalize

