//
//  CGIVirtualHost.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <CGIKit/CGIKit.h>

@class CGIServerRequest, CGIServerResponse;

@interface CGIVirtualHost : CGIHTTPServer

@property NSString *hostName;
@property NSString *serverRoot;

- (void)handleRequest:(CGIServerRequest *)request response:(CGIServerResponse *)response;

@end
