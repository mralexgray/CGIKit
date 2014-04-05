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
#import "NSScanner+CGIHTTPProtocolHandling.h"
#import "main.h"

@implementation CGIServerContext
{
    CGIServer *_server;
    int _socket;
    NSData *_address;
    
    dispatch_queue_t _contextQueue;
}

- (id)initWithServer:(CGIServer *)server socket:(int)socket address:(NSData *)address
{
    if (self = [super init])
    {
        _server = server;
        _socket = socket;
        _address = address;
        
        _contextQueue = dispatch_queue_create("info.maxchan.ochttpd.worker", 0);
    }
    return self;
}

- (void)processConnection
{
    dispatch_async(_contextQueue, ^{
        CGIServerRequest *request = [[CGIServerRequest alloc] init];
        CGIServerRequestStream *requestStream = [[CGIServerRequestStream alloc] initWithSocket:_socket];
        CGIBufferedInputStream *bufferedRequestStream = [[CGIBufferedInputStream alloc] initWithUnderlyingStream:requestStream];
        CGIServerResponse *response = [[CGIServerResponse alloc] init];
        CGIServerResponseStream *responseStream = [[CGIServerResponseStream alloc] initWithSocket:_socket];
        CGIBufferedOutputStream *bufferedResponseStream = [[CGIBufferedOutputStream alloc] initWithUnderlyingStream:responseStream];
        
        request.requestStream = bufferedRequestStream;
        response.responseStream = bufferedResponseStream;
        
        // Start to read the system status lines
        NSString *line = [[bufferedRequestStream readLine] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        tprintf(@"%@\n", line);
        
        do
        {
            NSString *method, *URI, *version;
            NSScanner *lineScanner = [NSScanner scannerWithString:line];
            if (![lineScanner scanHTTPMethod:&method URI:&URI protocolVersion:&version])
            {
                // Error!
            }
            
        } while (0);
        
        [_server contextDidFinish:self];
    });
}

@end
