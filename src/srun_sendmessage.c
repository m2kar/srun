#include <stdio.h>
#include <stdlib.h>

#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <time.h>

#include <unistd.h>

int port=3338 ;  //3338
int srun_sendmessage(char * id,char * mac_addr) {
    int socket_descriptor; //套接口描述字
    int iter=0;
    char buf[0x38];
	time_t timep;
	time (&timep); 
    struct sockaddr_in address;//处理网络通信的地址

    bzero(&address,sizeof(address));
    address.sin_family=AF_INET;
    address.sin_addr.s_addr=inet_addr("192.168.100.10");//这里不一样  192.168.100.10
    address.sin_port=htons(port);

    //创建一个 UDP socket

    socket_descriptor=socket(AF_INET,SOCK_DGRAM,0);//IPV4  SOCK_DGRAM 数据报套接字（UDP协议）
	
     for(iter=0x0;iter<0x38;iter++){
		 buf[iter]='\0';
      }
     strcpy(&buf[0],id);
     strcpy(&buf[0x20],mac_addr);
    sendto(socket_descriptor,buf,sizeof(buf),0,(struct sockaddr *)&address,sizeof(address));
    close(socket_descriptor);
	printf("%s",asctime(gmtime(&timep)));
	printf("ID=%s\nmac=%s\n",id,mac_addr);
    printf("Messages Sent,terminating\n\n");

    exit(0);

    return (EXIT_SUCCESS);
}
