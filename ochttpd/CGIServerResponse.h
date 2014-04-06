//
//  CGIServerResponse.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <CGIKit/CGIKit.h>

@interface CGIServerResponse : CGIHTTPResponse

@property NSMutableDictionary *headers;
@property CGIBufferedOutputStream *responseStream;

- (void)respondWithError:(NSString *)errorReason statusCode:(NSUInteger)statusCode;
- (void)respondWithIncompleteRequest;
- (void)respondWithForbiddenRequest;

- (void)sendHeader;
- (void)send;

@end
