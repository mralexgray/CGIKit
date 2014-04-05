//
//  CGIHTTPServer.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIServer.h"
#import "CGIServerContext.h"

@implementation CGIServer
{
    NSString *_host;
    NSUInteger _port;
    NSArray *_hosts;
    NSMutableArray *_contexts;
    
    GCDAsyncSocket *_listenSocket;
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
        
        _listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (BOOL)startWithError:(NSError *__autoreleasing *)error
{
    return [_listenSocket acceptOnInterface:_host port:_port error:error];
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    CGIServerContext *context = [[CGIServerContext alloc] initWithServer:self socket:newSocket];
    [_contexts addObject:context];
    [context processConnection];
}

- (void)contextDidFinish:(CGIServerContext *)context
{
    [_contexts removeObject:context];
}

@end
