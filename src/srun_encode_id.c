#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main(int argc,char * * argv)
{
	if(argc!=2) {
		exit (0);
	}
	int iter=0;
	char id[0x10];
	int len;
	len= strlen(argv[1]);
	for  (iter=0;iter<len;iter++)
	{
		id[iter]=argv[1][iter] + 4;
	}
	id[len]='\0';
	printf("{SRUN2}%s\n",id);
	return 0;
}

		
