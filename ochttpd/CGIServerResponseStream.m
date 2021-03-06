//
//  CGIServerResponseStream.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIServerResponseStream.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>

#import "CGIServerContext.h"
#import "main.h"

@implementation CGIServerResponseStream
{
    int _socket;
}

- (id)initWithSocket:(int)socket
{
    if (self = [super init])
    {
        _socket = socket;
    }
    return self;
}

- (BOOL)hasSpaceAvailable
{
    return YES;
}

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len
{
    tprintf(@"Trying to send buffer with length %lu to socket %u:\n%s", len, _socket, buffer);
    
    NSInteger rv = send(_socket, buffer, len, 0);
    if (rv < 0)
    {
        fprintf(stderr, "warning: IO error when writing: %s\n", strerror(errno));
        return 0;
    }
    else
        return rv;
}

@end
