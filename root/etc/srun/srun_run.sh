#echo "1" > /tmp/srun.lock

while true
do
	lua /etc/srun/srun_send.lua  
	sleep 49
	
done

#rm /tmp/srun.lock
