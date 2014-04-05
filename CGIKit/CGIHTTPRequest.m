//
//  CGIHTTPRequest.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIHTTPRequest.h"

NSString *const CGIHTTPRequestMethodGet = @"GET";
NSString *const CGIHTTPRequestMethodPost = @"POST";
NSString *const CGIHTTPRequestMethodHead = @"HEAD";

@implementation CGIHTTPRequest
{
    NSData *_request;
}

@dynamic URI, HTTPVersion, method, headers, request, requestStream;
@synthesize server = _server;

- (NSData *)request
{
    @synchronized (self)
    {
        if (!_request)
        {
            NSMutableData *data = [NSMutableData data];
            uint8_t *buffer = malloc(BUFSIZ);
            
            if (!buffer)
                return nil;
            
            NSInteger lengthRead = 0;
            do
            {
                lengthRead = [self.requestStream read:buffer maxLength:BUFSIZ];
                [data appendBytes:buffer length:lengthRead];
            }
            while (lengthRead >= BUFSIZ);
            
            _request = [NSData dataWithData:data];
            free(buffer);
        }
        
        return _request;
    }
}

@end
