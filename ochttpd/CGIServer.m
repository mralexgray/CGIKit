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

void _CGIServerRunLoopCancelCallBack(CGIServer *server, CFRunLoopRef rl, NSString *mode);
void _CGIServerRunLoopPerformCallBack(CGIServer *server);

@implementation CGIServer
{
    NSString *_host;
    NSUInteger _port;
    NSArray *_hosts;
    NSMutableArray *_contexts;
    
    CFRunLoopSourceRef _serverRunLoopSource;
    CFRunLoopSourceContext _serverRunLoopContext;
    
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

        if (_socketType == AF_INET)
        {
            // IPv4
            const struct sockaddr_in *addr = [_listenPort bytes];
            fprintf(stderr, "info: listening from IPv4 %s:%lu\n", inet_ntoa(addr->sin_addr), _port);
        }
        else
        {
            // IPv6
            const struct sockaddr_in6 *addr = [_listenPort bytes];
            char buf[128];
            inet_ntop(AF_INET6, &(addr->sin6_addr), buf, 128);
            fprintf(stderr, "info: listening from IPv6 [%s]:%lu\n", buf, _port);
        }
        
        // Start listening.
        listen(_listenSocket, 5);
        
        // Set up the run loop source
        _serverRunLoopContext.version = 0;
        _serverRunLoopContext.info = (__bridge void *)(self);
        _serverRunLoopContext.retain = CFRetain;
        _serverRunLoopContext.release = CFRelease;
        _serverRunLoopContext.copyDescription = CFCopyDescription;
        _serverRunLoopContext.equal = CFEqual;
        _serverRunLoopContext.hash = CFHash;
        _serverRunLoopContext.schedule = NULL;
        _serverRunLoopContext.cancel = (void *)_CGIServerRunLoopCancelCallBack;
        _serverRunLoopContext.perform = (void *)_CGIServerRunLoopPerformCallBack;
        
        _serverRunLoopSource = CFRunLoopSourceCreate(NULL, 0, &_serverRunLoopContext);
    }
    return self;
}

- (void)dealloc
{
    if (_serverRunLoopSource)
        CFRelease(_serverRunLoopSource);
}

- (void)accept
{
    char buf[128] = {0};
    socklen_t length = 0;
    
    int clientConnection = accept(_listenSocket, (void *)buf, &length);
    if (clientConnection < 0)
    {
        return;
    }
    
    if (fcntl(clientConnection, F_SETFL, O_NONBLOCK) < 0)
    {
        fprintf(stderr, "warning: cannot make client connection non-blocking: %s\n", strerror(errno));
        close(clientConnection);
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

- (void)arrangeNextRun
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceSignal(_serverRunLoopSource);
    CFRunLoopWakeUp(runLoop);
}

- (void)addToRunLoop:(NSRunLoop *)runLoop
{
    CFRunLoopRef rl = [runLoop getCFRunLoop];
    CFRunLoopAddSource(rl, _serverRunLoopSource, kCFRunLoopDefaultMode);
    [self arrangeNextRun];
}

- (void)removeFromRunLoop:(NSRunLoop *)runLoop
{
    CFRunLoopRef rl = [runLoop getCFRunLoop];
    CFRunLoopRemoveSource(rl, _serverRunLoopSource, kCFRunLoopDefaultMode);
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

void _CGIServerRunLoopCancelCallBack(CGIServer *server, CFRunLoopRef rl, NSString *mode)
{
    [server cleanUp];
}

void _CGIServerRunLoopPerformCallBack(CGIServer *server)
{
    [server accept];
    [server arrangeNextRun];
}
