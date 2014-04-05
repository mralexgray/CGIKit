//
//  CGIHTTPContext.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncSocket.h"

@class CGIServer;

@interface CGIServerContext : NSObject <GCDAsyncSocketDelegate>

- (id)initWithServer:(CGIServer *)server socket:(GCDAsyncSocket *)socket;

- (void)processConnection;

#pragma mark - Serialized reads and writes.

- (NSData *)readLength:(NSUInteger)length;
- (void)write:(NSData *)data;

@end
