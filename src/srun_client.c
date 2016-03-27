#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(int argc ,char * argv[])
{
	char id[0x10];
	char mac_address[0x18];
	if(argc==1){
		get_uci(id,mac_address);
		srun_sendmessage();
	}
	else if(argc==2 && strcmp(argv[1],"-h"){
		srun_help();
	}
	else{
		printf("\nsrun -h \n for help");
	}
	return 0;
	
}
