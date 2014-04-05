//
//  CGIHTTPServer.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGIServerContext;

@interface CGIServer : NSObject

@property (readonly) NSArray *hosts;

- (id)initOnHost:(NSString *)host port:(NSUInteger)port virtualHosts:(NSArray *)hosts;
- (void)accept;
- (void)cleanUp;

- (void)contextDidFinish:(CGIServerContext *)context;

@end
