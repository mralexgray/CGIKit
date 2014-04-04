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

@dynamic URI, HTTPVersion, method, headers, request, requestStream;

@end
