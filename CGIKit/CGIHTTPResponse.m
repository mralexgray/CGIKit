//
//  CGIHTTPResponse.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIHTTPResponse.h"

@implementation CGIHTTPResponse

@dynamic status, statusCode, headers, response, responseStream, HTTPVersion;

- (id)objectForKeyedSubscript:(NSString *)key
{
    return self.headers[key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key
{
    self.headers[key] = object;
}

@end
