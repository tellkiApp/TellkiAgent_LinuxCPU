###################################################################################################################
## This script was developed by Guberni and is part of Tellki monitoring solution                     		 	 ##
##                                                                                                      	 	 ##
## December, 2014                     	                                                                	 	 ##
##                                                                                                      	 	 ##
## Version 1.0                                                                                          	 	 ##
##																									    	 	 ##
## DESCRIPTION: Monitor CPU utilization																    	 	 ##
##																											 	 ##
## SYNTAX: ./cpu_Linux.sh <METRIC_STATE>             														 	 ##
##																											 	 ##
## EXAMPLE: ./cpu_Linux.sh "1,1,1,1,0"         														    	 	 ##
##																											 	 ##
##                                      ############                                                    	 	 ##
##                                      ## README ##                                                    	 	 ##
##                                      ############                                                    	 	 ##
##																											 	 ##
## This script is used combined with runremote.sh script, but you can use as standalone. 			    	 	 ##
##																											 	 ##
## runremote.sh - executes input script locally or at a remove server, depending on the LOCAL parameter.	 	 ##
##																											 	 ##
## SYNTAX: sh "runremote.sh" <HOST> <METRIC_STATE> <USER_NAME> <PASS_WORD> <TEMP_DIR> <SSH_KEY> <LOCAL> 	 	 ##
##																											 	 ##
## EXAMPLE: (LOCAL)  sh "runremote.sh" "cpu_Linux.sh" "192.168.1.1" "1,1,1,1,1" "" "" "" "" "1"              	 ##
## 			(REMOTE) sh "runremote.sh" "cpu_Linux.sh" "192.168.1.1" "1,1,1,1,1" "user" "pass" "/tmp" "null" "0"  ##
##																											 	 ##
## HOST - hostname or ip address where script will be executed.                                         		 ##
## METRIC_STATE - is generated internally by Tellki and its only used by Tellki default monitors.       	 	 ##
##         		  1 - metric is on ; 0 - metric is off					              						 	 ##
## USER_NAME - user name required to connect to remote host. Empty ("") for local monitoring.           	 	 ##
## PASS_WORD - password required to connect to remote host. Empty ("") for local monitoring.            	 	 ##
## TEMP_DIR - (remote monitoring only): directory on remote host to copy scripts before being executed.		 	 ##
## SSH_KEY - private ssh key to connect to remote host. Empty ("null") if password is used.                 	 ##
## LOCAL - 1: local monitoring / 0: remote monitoring                                                   	 	 ##
###################################################################################################################

#METRIC_ID
CPUUserTime="218:% CPU User Time:6"
CPUIdleTime="188:% CPU Idle Time:6"
CPUSystemTime="154:% CPU System Time:6"
CPUWaitTime="20:% CPU Wait I/O Time:6"
CPUTotalTime="222:% CPU Utilization:6"

#INPUTS
cpuidle_on=`echo $1 | awk -F',' '{print $3}'`
cpusystem_on=`echo $1 | awk -F',' '{print $2}'`
cpuuser_on=`echo $1 | awk -F',' '{print $1}'`
cpuwait_on=`echo $1 | awk -F',' '{print $4}'`
cputotal_on=`echo $1 | awk -F',' '{print $5}'`

vmstat_out=`vmstat 1 3 | tail -1`

cpuidle=`echo $vmstat_out | awk '{print $(15)}'` 
cpusystem=`echo $vmstat_out | awk '{print $(14)}'`
cpuuser=`echo $vmstat_out | awk '{print $(13)}'` 
cpuwait=`echo $vmstat_out | awk '{print $(16)}'`
cputotal=`expr $cpuuser + $cpusystem + $cpuwait`


# Validate if all metrics were collected correctly
if [ $cpuuser_on -eq 1 ] && [ "$cpuuser" = "" ]
then
		#Unable to collect metrics
		exit 8 
fi
if [ $cpusystem_on -eq 1 ] && [ "$cpusystem" = "" ]
then
		#Unable to collect metrics
		exit 8 
fi
if [ $cpuidle_on -eq 1 ] && [ "$cpuidle" = "" ]
then
		#Unable to collect metrics
		exit 8 
fi
if [ $cpuwait_on -eq 1 ] && [ "$cpuwait" = "" ]
then
		#Unable to collect metrics
		exit 8 
fi
if [ $cputotal_on -eq 1 ] && [ "$cputotal" = "" ]
then
		#Unable to collect metrics
		exit 8 
fi

# Send Metrics
if [ $cpuuser_on -eq 1 ]
then
 echo "$CPUUserTime|$cpuuser|"
fi 
if [ $cpusystem_on -eq 1 ]
then
 echo "$CPUSystemTime|$cpusystem|"
fi
if [ $cpuidle_on -eq 1 ]
then
 echo "$CPUIdleTime|$cpuidle|"
fi
if [ $cpuwait_on -eq 1 ]
then
 echo "$CPUWaitTime|$cpuwait|"
fi
if [ $cputotal_on -eq 1 ] 
then
 echo "$CPUTotalTime|$cputotal|"
fi

