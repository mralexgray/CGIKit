//
//  CGIWebCoordinator.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGIHTTPRequest, CGIHTTPResponse, CGIHTTPServer;

extern NSString *const CGIWebCoordinatorPortName;

@interface CGIWebCoordinator : NSObject

- (int)handleRequest:(in CGIHTTPRequest *)request
        withResponse:(inout CGIHTTPResponse *)response;

@end
