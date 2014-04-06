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
    
    NSThread *_contextThread;
}

- (id)initWithServer:(CGIServer *)server socket:(int)socket address:(NSData *)address
{
    if (self = [super init])
    {
        _server = server;
        _socket = socket;
        _address = address;
        
        _contextThread = [[NSThread alloc] initWithTarget:self selector:@selector(_process) object:nil];
        [_contextThread setName:@"info.maxchan.ochttpd.worker"];
    }
    return self;
}

- (void)processConnection
{
    [_contextThread start];
}

- (void)_process
{
    @autoreleasepool
    {
        CGIServerRequest *request = [[CGIServerRequest alloc] init];
        CGIServerRequestStream *requestStream = [[CGIServerRequestStream alloc] initWithSocket:_socket];
        CGIBufferedInputStream *bufferedRequestStream = [[CGIBufferedInputStream alloc] initWithUnderlyingStream:requestStream];
        CGIServerResponse *response = [[CGIServerResponse alloc] init];
        CGIServerResponseStream *responseStream = [[CGIServerResponseStream alloc] initWithSocket:_socket];
        CGIBufferedOutputStream *bufferedResponseStream = [[CGIBufferedOutputStream alloc] initWithUnderlyingStream:responseStream];
        
        // Start to read the system status lines
        NSString *line = [[bufferedRequestStream readLine] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        tprintf(@"%@\n", line);
        
        do
        {
            BOOL dead = NO;
            
            NSString *method, *URI, *version;
            NSScanner *lineScanner = [NSScanner scannerWithString:line];
            if (![lineScanner scanHTTPMethod:&method URI:&URI protocolVersion:&version])
            {
                // Error!
                [response respondWithIncompleteRequest];
                break;
            }
            request.method = [method stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            request.URI = [URI stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            request.HTTPVersion = [version stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSMutableDictionary *fields = [NSMutableDictionary dictionary];
            
            while ([(line = [[bufferedRequestStream readLine] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]) length])
            {
                tprintf(@"%@\n", line);
                
                NSString *key, *value;
                NSScanner *scanner = [NSScanner scannerWithString:line];
                if (![scanner scanHTTPHeaderField:&key value:&value])
                {
                    [response respondWithIncompleteRequest];
                    dead = YES;
                    break;
                }
                
                if (fields[key])
                {
                    id object = fields[key];
                    if ([object isKindOfClass:[NSArray class]])
                        fields[key] = [object arrayByAddingObject:value];
                    else
                        fields[key] = @[object, [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                }
                else
                {
                    fields[key] = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
            }
            if (dead)
                break;
            
            request.headers = [NSDictionary dictionaryWithDictionary:fields];
            
            // dispatch the thing
            request.requestStream = bufferedRequestStream;
            response.responseStream = bufferedResponseStream;
            
            for (NSInteger i = [_server.hosts count] - 1; i > 0; i--)
            {
                CGIVirtualHost *host = _server.hosts[i];
                
                if ([host.hostName compare:request.headers[@"Host"] options:NSCaseInsensitiveSearch] == NSOrderedSame || ![host.hostName length])
                {
                    [host handleRequest:request response:response];
                    dead = YES;
                }
            }
            
            if (!dead)
            {
                [response respondWithForbiddenRequest];
            }
            
        } while (0);
        
        [response send];
        
        close(_socket);
        [_server contextDidFinish:self];
    }
}

@end
