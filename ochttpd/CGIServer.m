//
//  CGIHTTPServer.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIServer.h"
#import "CGIServerContext.h"
#import "main.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <netdb.h>

@implementation CGIServer
{
    NSString *_host;
    NSUInteger _port;
    NSArray *_hosts;
    NSMutableArray *_contexts;
    
    int _listenSocket;
    NSData *_listenPort;
    int _socketType;
}

@synthesize hosts = _hosts;

- (id)initOnHost:(NSString *)host port:(NSUInteger)port virtualHosts:(NSArray *)hosts
{
    if (self = [super init])
    {
        _host = host;
        _port = port;
        _hosts = hosts;
        _contexts = [NSMutableArray array];
        
        if (_host)
        {
            // Look for the host address and determine if I should use IPv4 or IPv6 connection.
            struct addrinfo addrhint = { AI_NUMERICHOST | AI_PASSIVE, AF_UNSPEC, SOCK_STREAM, 0, 0, NULL, NULL, NULL };
            struct addrinfo *addressInfo = NULL;
            if (getaddrinfo([_host UTF8String], [[NSString stringWithFormat:@"%lu", _port] UTF8String], &addrhint, &addressInfo) < 0)
                return self = NULL;
            
            if (!addressInfo)
                return self = nil;
            
            _socketType = addressInfo->ai_family;
            switch (_socketType)
            {
                case AF_INET: // IPv4
                {
                    struct sockaddr_in server_addr;
                    bzero(&server_addr, sizeof(server_addr));
                    server_addr.sin_port = htons((uint16_t)_port);
                    server_addr.sin_family = AF_INET;
                    server_addr.sin_addr.s_addr = inet_addr([_host UTF8String]);
                    
                    _listenPort = [NSData dataWithBytes:&server_addr length:sizeof(struct sockaddr_in)];
                }
                    break;
                case AF_INET6: // IPv6
                {
                    struct sockaddr_in6 server_addr;
                    bzero(&server_addr, sizeof(server_addr));
                    server_addr.sin6_port = htons((uint16_t)_port);
                    server_addr.sin6_family = AF_INET6;
                    inet_pton(AF_INET6, [_host UTF8String], &server_addr.sin6_addr);
                    
                    _listenPort = [NSData dataWithBytes:&server_addr length:sizeof(struct sockaddr_in6)];
                }
                    break;
                default:
                    errno = ESOCKTNOSUPPORT;
                    return self = nil;
                    break;
            }
            
            freeaddrinfo(addressInfo);
        }
        else
        {
            // Go to [::]:port
            struct sockaddr_in6 server_addr;
            bzero(&server_addr, sizeof(struct sockaddr_in6));
            server_addr.sin6_port = htons((uint16_t)_port);
            server_addr.sin6_family = _socketType = AF_INET6;
            server_addr.sin6_addr = in6addr_any;
            
            _listenPort = [NSData dataWithBytes:&server_addr length:sizeof(struct sockaddr_in6)];
        }
        
        // Create the socket.
        _listenSocket = socket(_socketType, SOCK_STREAM, 0);
        if (_listenSocket < 0)
            return self = nil;
        
        // Bind it
        if (bind(_listenSocket, [_listenPort bytes], (socklen_t)[_listenPort length]) < 0)
            return self = nil;
        
#if DEBUG
        if (_socketType == AF_INET)
        {
            // IPv4
            const struct sockaddr_in *addr = [_listenPort bytes];
            tprintf(@"Listening from IPv4 %s:%lu\n", inet_ntoa(addr->sin_addr), _port);
        }
        else
        {
            // IPv6
            const struct sockaddr_in6 *addr = [_listenPort bytes];
            char buf[128];
            inet_ntop(AF_INET6, &(addr->sin6_addr), buf, 128);
            tprintf(@"Listening from IPv6 [%s]:%lu\n", buf, _port);
        }
#endif
        
        // Start listening.
        listen(_listenSocket, 5);
        
    }
    return self;
}

- (void)accept
{
    char buf[128] = {0};
    socklen_t length = 0;
    
    int clientConnection = accept(_listenSocket, (void *)buf, &length);
    if (clientConnection < 0)
    {
        fprintf(stderr, "error: cannot accept client connection: %s\n", strerror(errno));
        keep_alive = NO;
        return;
    }
    
    CGIServerContext *context = [[CGIServerContext alloc] initWithServer:self socket:clientConnection address:[NSData dataWithBytes:buf length:length]];
    if (!context)
    {
        fprintf(stderr, "warning: have to drop a connection due to fail to instantiate a session.\n");
        close(clientConnection);
        return;
    }
    
    [_contexts addObject:context];
    [context processConnection];
}

- (void)cleanUp
{
    fprintf(stderr, "info: ochttpd terminating.");
    close(_listenSocket);
}

- (void)contextDidFinish:(CGIServerContext *)context
{
    [_contexts removeObject:context];
}

@end
