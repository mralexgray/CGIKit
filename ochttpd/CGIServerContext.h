//
//  CGIHTTPContext.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGIServer;

@interface CGIServerContext : NSObject

- (id)initWithServer:(CGIServer *)server socket:(int)socket address:(NSData *)address;

- (void)processConnection;

@end
