srun: srun.c srun_sendmessage.c srun_encode_id.c wan_mac_addr.c
	$(CC) $(LDFLAG) srun.c srun_sendmessage.c -o srun
	$(CC) $(LDFLAG) srun_encode_id.c -o encode
	$(CC) $(LDFLAG) wan_mac_addr.c -o wan_mac
clean:
	rm *.o srun encode wan_mac

