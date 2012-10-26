#! /bin/bash 

#Sleep Time is currently not used            
sleepTime=1000


# do the overall test, this many times
for i in {1..6}
do
    warps=1
    blocks=7
    numJobs=$(($warps*$blocks*64))

    for k in {1..6}
    do
	(/usr/bin/time -f "%e" ./bin/run $warps $blocks $numJobs) 2>> logs/log.txt

	warps=$(($warps+$warps))
        numJobs=$(($warps*$blocks*64))
    done
  sleepTime=$(($sleepTime+$sleepTime))
done
