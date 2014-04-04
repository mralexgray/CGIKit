//
//  CGIHTTPServer.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIHTTPServer : NSObject

- (NSString *)stringByURLEncodingString:(NSString *)string;
- (NSString *)stringByURLDecodingString:(NSString *)string;
- (NSString *)stringByHTMLEncodingString:(NSString *)string;
- (NSString *)stringByHTMLDecodingString:(NSString *)string;

- (NSString *)absolutePathForRelativePath:(NSString *)path;
- (NSURL *)absoluteURLForRelativePath:(NSString *)path;

@end
