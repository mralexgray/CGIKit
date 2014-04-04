//
//  CGIHTTPServer.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIHTTPServer.h"

@implementation CGIHTTPServer

- (NSString *)stringByURLEncodingString:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                     (__bridge CFStringRef)string,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     kCFStringEncodingUTF8));
}

- (NSString *)stringByURLDecodingString:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)string,
                                                                        NULL));
}

- (NSString *)stringByHTMLEncodingString:(NSString *)string
{
    return CFBridgingRelease(CFXMLCreateStringByEscapingEntities(NULL,
                                                                 (__bridge CFStringRef)string,
                                                                 NULL));
}

- (NSString *)stringByHTMLDecodingString:(NSString *)string
{
    return CFBridgingRelease(CFXMLCreateStringByUnescapingEntities(NULL,
                                                                   (__bridge CFStringRef)string,
                                                                   NULL));
}

- (NSString *)absolutePathForRelativePath:(NSString *)path
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSURL *)absoluteURLForRelativePath:(NSString *)path
{
    return [[NSURL alloc] initFileURLWithPath:path];
}

@end
