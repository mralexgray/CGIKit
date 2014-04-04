//
//  CGIApacheRequest.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIApacheRequest.h"

@implementation CGIApacheRequest
{
    request_rec *_request;
}

@synthesize headers = _headers;
@synthesize requestStream = _requestStream;

- (id)initWithApacheRequest:(request_rec *)request
{
    if (self = [super init])
    {
        _request = request;
    }
    return self;
}

- (NSString *)method
{
    return @(_request->method);
}

- (NSString *)URI
{
    return @(_request->unparsed_uri);
}

- (NSString *)HTTPVersion
{
    return @(_request->protocol);
}

@end
