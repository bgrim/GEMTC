
# generated by stc
# date: 2012/11/13 17:07:44

package require turbine 0.0.6
namespace import turbine::*


proc swift:constants {  } {
    turbine::c::log "function:swift:constants"
    global c:f_0.0
    turbine::allocate c:f_0.0 float
    turbine::store_float ${c:f_0.0} 0.0
}

package require setup 0.0.1


proc swift:main {  } {
    turbine::c::log "enter function: main"
    set stack 0
    turbine::allocate u:x float
    turbine::allocate u:y float
    global c:f_0.0
    # Swift l.8: assigning expression to x
    setup::c_setup ${stack} [ list ${u:x} ] [ list ${c:f_0.0} ]
    # Swift l.12: assigning expression to y
    setup::c_run ${stack} [ list ${u:y} ] [ list ${c:f_0.0} ]
    turbine::c::rule main-explicitwait0 [ list ${u:x} ] ${turbine::LOCAL} [ list main-explicitwait0 ${stack} ]
    turbine::c::rule main-explicitwait1 [ list ${u:y} ] ${turbine::LOCAL} [ list main-explicitwait1 ${stack} ]
}


proc main-explicitwait0 { stack } {
    # Swift l.10 evaluating  expression and throwing away 0 results
    turbine::printf_local "Working 1"
}


proc main-explicitwait1 { stack } {
    # Swift l.14 evaluating  expression and throwing away 0 results
    turbine::printf_local "Working 2"
}

turbine::defaults
turbine::init $engines $servers
turbine::start swift:main swift:constants
turbine::finalize

