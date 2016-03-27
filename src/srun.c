#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int main(int argc,char * argv[])
{
	if( argc != 3) 	exit(1);
	srun_sendmessage(argv[1],argv[2]);
	return 0;
}
