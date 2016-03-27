    #include <stdio.h>  
    #include <stdlib.h>  
    #include <sys/ioctl.h>  
    #include <string.h>  
    #include <sys/types.h>  
    #include <sys/socket.h>  
    #include <net/if.h>  
    #include <netinet/in.h>  
      
    typedef signed   char   INT8S;  
    typedef unsigned char   INT8U;  
    typedef signed   short  INT16S;  
    typedef unsigned short  INT16U;  
    typedef signed   int    INT32S;  
    typedef unsigned int    INT32U;  
      
      
      

    //add by lightd, 2014-06-04  
    //============================================================================  
    //Function:    GetLocalMACAddr_API   
    //Description: 获取本地指定网卡的MAC  
    //Input:               
    //Output:          
    //Return:                     
    //Others:      None  
    //============================================================================  
    INT8S GetLocalMACAddr_API(const INT8U *interface_name, INT8U *str_macaddr)    
    {    
        INT32S       sock_fd;    
        struct ifreq ifr_mac;    
          
        //传入参数合法性检测  
        if(interface_name == NULL || str_macaddr == NULL)  
        {  
            fprintf(stdout, "%s:%d: args invalid!",  __FUNCTION__, __LINE__);  
            return -1;  
        }  
          
        sock_fd = socket( AF_INET, SOCK_STREAM, 0 );    
        if( sock_fd == -1)    
        {    
            perror("create socket failed");    
            sprintf((char *)str_macaddr, "00:00:00:00:00:00");  
            return -2;    
        }    
            
        //指定网卡  
        memset(&ifr_mac, 0, sizeof(ifr_mac));       
        sprintf(ifr_mac.ifr_name, "%s", interface_name);       
        
        //获取指定网卡的mac地址  
        if( (ioctl( sock_fd, SIOCGIFHWADDR, &ifr_mac)) < 0 )   
        {    
            perror("mac ioctl error");    
            sprintf((char *)str_macaddr, "00:00:00:00:00:00");  
            return -3;    
        }    
            
        close( sock_fd );    
          
        sprintf((char *)str_macaddr,"%02x:%02x:%02x:%02x:%02x:%02x",    
                (unsigned char)ifr_mac.ifr_hwaddr.sa_data[0],    
                (unsigned char)ifr_mac.ifr_hwaddr.sa_data[1],    
                (unsigned char)ifr_mac.ifr_hwaddr.sa_data[2],    
                (unsigned char)ifr_mac.ifr_hwaddr.sa_data[3],    
                (unsigned char)ifr_mac.ifr_hwaddr.sa_data[4],    
                (unsigned char)ifr_mac.ifr_hwaddr.sa_data[5]);    
        
        //printf("local mac:<%s> \n", str_macaddr);        
        int len=strlen((char *)str_macaddr);
	int iter=0;
	for(iter=0;iter<len;iter++){
		if(str_macaddr[iter]>='a' && str_macaddr[iter]<='z') {
			str_macaddr[iter]-=('a'-'A');
		//	printf("%d",iter);
		}
	}
        return 0;  
    }  
      
      
      
    int main(void)  
    {  
        INT8U str_macaddr[20];  
          
        memset(str_macaddr, 0, sizeof(str_macaddr));  
        GetLocalMACAddr_API("eth1", str_macaddr);  
	
        fprintf(stdout, "%s\n", str_macaddr);  
          
      
        return 0;  
    }  
