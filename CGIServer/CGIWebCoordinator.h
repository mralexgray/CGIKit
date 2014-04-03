//
//  CGIWebCoordinator.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGIHTTPRequest;
@class CGIHTTPResponse;
@class CGIHTTPContext;

@interface CGIWebCoordinator : NSObject

- (BOOL)handleRequest:(in CGIHTTPRequest *)request withResponse:(inout CGIHTTPResponse *)response;
- (BOOL)migrateContext:(inout CGIHTTPContext *)context;

@end
