
# generated by stc
# date: 2012/11/13 14:56:13

package require turbine 0.0.6
namespace import turbine::*


proc swift:constants {  } {
    turbine::c::log "function:swift:constants"
    global c:f_0.0
    turbine::allocate c:f_0.0 float
    turbine::store_float ${c:f_0.0} 0.0
    global c:i_1
    turbine::allocate c:i_1 integer
    turbine::store_integer ${c:i_1} 1
}

package require run 0.0.1


proc swift:main {  } {
    turbine::c::log "enter function: main"
    set stack 0
    turbine::allocate_container t:0 integer
    global c:i_1
    turbine::rangestep ${stack} [ list ${t:0} ] [ list ${c:i_1} ${c:i_1} ${c:i_1} ]
    turbine::c::rule main-foreach_arr_wait0 [ list ${t:0} ] ${turbine::LOCAL} [ list main-foreach_arr_wait0 ${stack} ${t:0} ]
}


proc main-foreach_arr_wait0 { stack t:0 } {
    set tcltmp:contents [ adlb::enumerate ${t:0} members all 0 ]
    foreach u:i ${tcltmp:contents} {
        turbine::allocate u:y float
        global c:f_0.0
        # Swift l.11: assigning expression to y
        run::c_run ${stack} [ list ${u:y} ] [ list ${c:f_0.0} ]
        turbine::c::rule main-explicitwait0 [ list ${u:y} ] ${turbine::LOCAL} [ list main-explicitwait0 ${stack} ]
    }
}


proc main-explicitwait0 { stack } {
    # Swift l.13 evaluating  expression and throwing away 0 results
    turbine::printf_local "Working"
}

turbine::defaults
turbine::init $engines $servers
turbine::start swift:main swift:constants
turbine::finalize

