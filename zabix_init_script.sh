#! /bin/sh
counter=0
zabbix_counter=$(ps -ef | grep zabbix_agentd | grep -v grep | wc -l)

start(){
echo "-------------------------------------------------------------------"
echo " LAUNCHING ZABBIX AGENT"

if [ $zabbix_counter -gt 0 ]; then
echo " * Zabbix agent was previously running"
echo " * Number of zabbix agentd instances= $zabbix_counter"
echo "-----------------------------------------------------------------"
fi

# Checking if the user is able to start the agent.... if the user is not able to, we make a su to
# the user zabbix and start the agent

if [ $(whoami) != "zabbix" ];then
sudo -u zabbix zabbix_agentd
else
# We are the zabbix user, so we can start the agent.
zabbix_agentd
fi
sleep 10

zabbix_counter=$(ps -ef | grep zabbix_agentd | grep -v grep | wc -l)
if [ $zabbix_counter -gt 0 ]; then
echo " * Zabbix agent succesfully launched"
echo " * Number of zabbix agentd instances= $zabbix_counter"
echo "-------------------------------------------------------------------"
else
echo " * Zabbix agent can't be launched, check zabbix logs"
echo "-------------------------------------------------------------------"
fi

}

stop(){
# Checking if the user is able to start the agent.... if the user is not able to, we make a su to
# the user zabbix and kill the agent. Also we try to kill it for 5 times using a counter, if at
# the fith try the agent is still there, we launch a message to the console.

echo "-------------------------------------------------------------------"
echo " STOPPING ZABBIX AGENT"

if [ $zabbix_counter -eq 0 ]; then
echo " * Zabbix agent was not running on this machine"
echo "-------------------------------------------------------------------"
fi

while [ $zabbix_counter -gt 0 ] && [ $counter -lt 5 ] ; do

let counter=counter+1

echo " * Number of Attempts (Max 5)=$counter"
echo " * Stopping zabbix.."
echo " * Number of zabbix agentd instances= $zabbix_counter"

if [ $(whoami) != "zabbix" ];then
sudo -u zabbix killall zabbix_agentd > /dev/null &
else
killall zabbix_agentd > /dev/null &
fi

sleep 10
# We make a 10 seconds delay to avoid the state defunct of the process, if we delete it,
# will enter again on the iteration and will show an error when he tries to kill the process.
# After 10 seconds we check again the number of zabbix_agentd processes running,
# if it's 0 will exit of the iteration and follow the code

zabbix_counter =$(ps -ef | grep zabbix_agentd | grep -v grep | wc -l)

done

if [ $zabbix_counter -gt 0 ]; then
echo "It was not possible to stop the agent, look at th zabbix logs"
echo "-------------------------------------------------------------------"
fi

if [ $zabbix_counter -eq 0 ]; then
echo " * Zabbix agent properly stopped"
echo "-------------------------------------------------------------------"
fi

}

restart(){
stop
# give stuff some time to stop before we restart
sleep 10
# Now we can start the agent again.
start
}



case "$1" in
start)
start
;;
stop)
stop
;;
restart)
restart
;;
*)
echo "Usage: zabbix {start|stop|restart}"
exit 1
esac

exit 0
