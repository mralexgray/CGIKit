//
//  CGIApacheServer.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIApacheServer.h"

@implementation CGIApacheServer
{
    server_rec *_server;
}

- (id)initWithApacheServer:(server_rec *)server
{
    if (self = [super init])
    {
        _server = server;
    }
    return self;
}

- (NSString *)absolutePathForRelativePath:(NSString *)path
{
    NSArray *pathComponents = [path pathComponents];
    NSString *base = @(_server->path);
    
    for (NSString *component in pathComponents)
    {
        base = [base stringByAppendingString:component];
    }
    
    return base;
}

@end
