//
//  CGIApacheOutputStream.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIApacheOutputStream.h"

#import <httpd.h>
#import <http_log.h>

#import <http_core.h>
#import <http_connection.h>
#import <http_request.h>
#import <http_protocol.h>

@implementation CGIApacheOutputStream
{
    request_rec *_request;
}

- (id)initWithApacheRequest:(request_rec *)request
{
    if (self = [super init])
    {
        _request = request;
    }
    return self;
}

- (BOOL)hasSpaceAvailable
{
    return YES;
}

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len
{
    return ap_rwrite(buffer, (int)len, _request);
}

@end
