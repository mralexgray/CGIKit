//
//  CGIWebCoordinator.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIWebCoordinator.h"

NSString *const CGIWebCoordinatorPortName = @"CGIWebCoordinator";

@implementation CGIWebCoordinator

- (int)handleRequest:(in CGIHTTPRequest *)request withResponse:(inout CGIHTTPResponse *)response
{
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

@end
