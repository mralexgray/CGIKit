//
//  CGIServerRequest.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIServerRequest.h"

@implementation CGIServerRequest

@synthesize URI = _URI;
@synthesize HTTPVersion = _HTTPVersion;
@synthesize method = _method;
@synthesize headers = _headers;
@synthesize request = _request;
@synthesize requestStream = _requestStream;
@synthesize server = _server;

@end
