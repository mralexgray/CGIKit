//
//  CGIVirtualHost.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIVirtualHost.h"

@implementation CGIVirtualHost

- (NSString *)absolutePathForRelativePath:(NSString *)path
{
    NSArray *pathComponents = [path pathComponents];
    NSString *base = self.serverRoot;
    
    for (NSString *component in pathComponents)
    {
        base = [base stringByAppendingString:component];
    }
    
    return base;
}

- (void)handleRequest:(CGIServerRequest *)request response:(CGIServerResponse *)response
{
    
}

@end
