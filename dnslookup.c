#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <errno.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/in.h>

int main(int argc, char *argv[]) {

    if(argc < 2){
        printf("Missing  hostname!\n");
        exit(1);
    }

    struct addrinfo hints, *results, *p;
    int rv;
    char ipstr[INET6_ADDRSTRLEN];

    memset(&hints, 0 ,sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    for(int i = 1; i < argc; i++){

        if((rv = getaddrinfo(argv[i], NULL, &hints, &results)) != 0){
            fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
            return 1;
        }

        for(p = results; p!=NULL;p = p->ai_next){
            void *addr;
            void *ipver;

            if(p->ai_family == AF_INET){
                struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
                addr = &(ipv4->sin_addr);
                ipver = "IPv4";
                inet_ntop(p->ai_family, addr, ipstr, sizeof ipstr);
                printf("%s %s %s\n", argv[i], ipver, ipstr);
            }
        }

        for(p = results; p!=NULL;p = p->ai_next){
            void *addr;
            void *ipver;

            if(p->ai_family == AF_INET6){
                struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)p->ai_addr;
                addr = &(ipv6->sin6_addr);
                ipver = "IPv6";
                inet_ntop(p->ai_family, addr, ipstr, sizeof ipstr);
                printf("%s %s %s\n", argv[i], ipver, ipstr);
            }
        }
    }
    freeaddrinfo(results);
    printf("\n");

}