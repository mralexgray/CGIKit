//
//  NSScanner+CGIHTTPProtocolHandling.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSScanner (CGIHTTPProtocolHandling)

- (BOOL)scanHTTPMethod:(NSString **)method URI:(NSString **)URI protocolVersion:(NSString **)protocolVersion;
- (BOOL)scanHTTPHeaderField:(NSString **)field value:(NSString **)value;

@end
