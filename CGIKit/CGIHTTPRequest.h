//
//  CGIHTTPRequest.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CGIHTTPRequestMethodGet;
extern NSString *const CGIHTTPRequestMethodPost;
extern NSString *const CGIHTTPRequestMethodHead;

@class CGIHTTPServer;

@interface CGIHTTPRequest : NSObject

@property (readonly) NSString *URI;
@property (readonly) NSString *HTTPVersion;
@property (readonly) NSString *method;
@property (readonly) NSDictionary *headers;
@property (readonly) NSData *request;
@property (readonly) NSInputStream *requestStream;
@property (readonly) CGIHTTPServer *server;

@end
