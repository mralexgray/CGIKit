//
//  CGIHTTPResponse.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIHTTPResponse : NSObject

@property NSUInteger statusCode;
@property NSString *status;
@property NSString *HTTPVersion;
@property (readonly) NSMutableDictionary *headers;
@property NSMutableData *response;
@property (readonly) NSOutputStream *responseStream;

- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

@end
