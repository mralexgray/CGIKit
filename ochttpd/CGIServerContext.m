//
//  CGIHTTPContext.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIServerContext.h"

#import "CGIServer.h"
#import "CGIServerRequest.h"
#import "CGIServerRequestStream.h"
#import "CGIServerResponse.h"
#import "CGIServerResponseStream.h"
#import "CGIVirtualHost.h"

#import "GCDAsyncSocket.h"
#import "main.h"

@implementation CGIServerContext
{
    CGIServer *_server;
    GCDAsyncSocket *_socket;
    dispatch_queue_t _contextQueue;
    
    NSCondition *_readCondition;
    NSCondition *_writeCondition;
    
    NSLock *_readLock;
    NSLock *_writeLock;
    
    NSData *_readData;
}

- (id)initWithServer:(CGIServer *)server socket:(GCDAsyncSocket *)socket
{
    if (self = [super init])
    {
        _server = server;
        _socket = socket;
        _contextQueue = dispatch_queue_create("info.maxchan.ochttpd.worker", 0);
        _readCondition = [[NSCondition alloc] init];
        _writeCondition = [[NSCondition alloc] init];
        _readLock = [[NSLock alloc] init];
        _writeLock = [[NSLock alloc] init];
        
        [_socket setDelegate:self delegateQueue:_contextQueue];
    }
    return self;
}

- (void)processConnection
{
    dispatch_async(_contextQueue, ^{
        tprintf(@"incoming from [%@]:%u\n", _socket.connectedHost, _socket.connectedPort);
        CGIServerRequest *request = [[CGIServerRequest alloc] init];
        CGIServerRequestStream *requestStream = [[CGIServerRequestStream alloc] initWithContext:self];
        
        [_server contextDidFinish:self];
    });
}

#pragma mark - Serialized access

- (NSData *)readLength:(NSUInteger)length
{
    if (![_readLock tryLock]) // Try to lock the input stream.
    {
        [_readCondition wait]; // Wait if failed.
    
        if (![_readLock tryLock]) // Try again.
            return nil; // Fail if still not locked.
    }
    
    // Now we have locked the read stream, branch and read.
    [_socket readDataToLength:length withTimeout:-1 tag:(long)_readLock];
    
    // Wait for it to end.
    [_readCondition wait];
    
    NSData *outputData = _readData;
    [_readLock unlock];
    
    return outputData;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (tag != (long)_readLock)
        return;
    
    _readData = data;
    [_readCondition broadcast];
}

- (void)write:(NSData *)data
{
    if (![_writeLock tryLock])
    {
        [_writeCondition wait];
        
        if (![_writeLock tryLock])
            return;
    }
    
    [_socket writeData:data withTimeout:-1 tag:(long)_writeLock];
    
    [_writeCondition wait];
    
    [_writeLock unlock];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (tag != (long)_writeLock)
        return;
    
    [_writeCondition broadcast];
}

@end
