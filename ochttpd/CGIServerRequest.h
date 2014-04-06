//
//  CGIServerRequest.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <CGIKit/CGIKit.h>

@interface CGIServerRequest : CGIHTTPRequest

@property NSString *URI;
@property NSString *HTTPVersion;
@property NSString *method;
@property NSDictionary *headers;
@property NSData *request;
@property CGIBufferedInputStream *requestStream;
@property CGIHTTPServer *server;

@end
