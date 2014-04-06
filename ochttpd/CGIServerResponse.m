//
//  CGIServerResponse.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIServerResponse.h"

#import "main.h"

@implementation CGIServerResponse
{
    BOOL _headerSent;
    BOOL _sent;
}

@synthesize status = _status;
@synthesize statusCode = _statusCode;
@synthesize headers = _headers;
@synthesize response = _response;
@synthesize responseStream = _responseStream;
@synthesize HTTPVersion = _HTTPVersion;

- (id)init
{
    if (self = [super init])
    {
        _HTTPVersion = @"HTTP/1.0";
        _statusCode = 200;
        _headers = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"Content-Type": @"text/plain; charset=utf-8",
                                                                   @"Connection": @"close",
                                                                   }];
        _response = [NSMutableData data];
    }
    return self;
}

- (void)respondWithError:(NSString *)errorReason statusCode:(NSUInteger)statusCode
{
    
}

- (void)respondWithForbiddenRequest
{
    
}

- (void)respondWithIncompleteRequest
{
    
}

#if DEBUG
#define twrite(fmt, ...) @"%@", ({ NSString *s = [NSString stringWithFormat:fmt, ##__VA_ARGS__]; tprintf(@"%@", s); s; })
#else
#define twrite(fmt, ...) fmt, ##__VA_ARGS__
#endif

- (void)sendHeader
{
    if (_headerSent || !_responseStream)
        return;
    
    _headerSent = YES;
    
    if (!_status)
    {
        NSDictionary *defaultStatus = @{
                                        @100: @"Continue",
                                        @101: @"Switching Protocols",
                                        @200: @"OK",
                                        @201: @"Created",
                                        @202: @"Accepted",
                                        @203: @"Non-Authoritative Information",
                                        @204: @"No Content",
                                        @205: @"Reset Content",
                                        @206: @"Partial Content",
                                        @300: @"Multiple Choices",
                                        @301: @"Moved Permanently",
                                        @302: @"Found",
                                        @303: @"See Other",
                                        @304: @"Not Modified",
                                        @305: @"Use Proxy",
                                        @307: @"Temporary Redirect",
                                        @400: @"Bad Request",
                                        @401: @"Unauthorized",
                                        @402: @"Payment Required",
                                        @403: @"Forbidden",
                                        @404: @"Not Found",
                                        @405: @"Method Not Allowed",
                                        @406: @"Not Acceptable",
                                        @407: @"Proxy Authentication Required",
                                        @408: @"Request Timeout",
                                        @409: @"Conflict",
                                        @410: @"Gone",
                                        @411: @"Length Required",
                                        @412: @"Precondition Failed",
                                        @413: @"Request Entity Too Large",
                                        @414: @"Request-URI Too Long",
                                        @415: @"Unsupported Media Type",
                                        @416: @"Requested Range Not Satisfiable",
                                        @417: @"Expectation Failed",
                                        @500: @"Internal Server Error",
                                        @501: @"Not Implemented",
                                        @502: @"Bad Gateway",
                                        @503: @"Service Unavailable",
                                        @504: @"Gateway Timeout",
                                        @505: @"HTTP Version Not Supported",
                                        };
        _status = defaultStatus[@(_statusCode)];
        
        if (!_status)
            _status = @"Unknown";
    }
    
    [_responseStream writeWithFormat:twrite(@"%lu %@ %@\r\n", _statusCode, _status, _HTTPVersion)];
    
    for (NSString *key in _headers)
    {
        id object = _headers[key];
        
        if ([object isKindOfClass:[NSArray class]])
        {
            for (id item in object)
            {
                [_responseStream writeWithFormat:twrite(@"%@: %@\r\n", key, item)];
            }
        }
        else
        {
            [_responseStream writeWithFormat:twrite(@"%@: %@\r\n", key, object)];
        }
    }
    
    [_responseStream writeWithFormat:twrite(@"\r\n")];
}

- (CGIBufferedOutputStream *)responseStream
{
    @synchronized (self)
    {
        if (!_headerSent)
            [self sendHeader];
        
        return _responseStream;
    }
}

- (void)setResponseStream:(CGIBufferedOutputStream *)responseStream
{
    @synchronized (self)
    {
        _responseStream = responseStream;
    }
}

- (void)send
{
    if (_sent)
        return;
    
    _sent = YES;
    
    if (!_headerSent)
        [self sendHeader];
    
    tprintf(@"data sent.\n");
    
    if ([_response length])
        [_responseStream writeData:_response];
}

@end
