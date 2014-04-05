//
//  CGIBufferedOutputStream.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIBufferedOutputStream : NSOutputStream

@property (readonly) NSOutputStream *underlyingStream;

- (id)initWithUnderlyingStream:(NSOutputStream *)stream;

- (NSInteger)writeData:(NSData *)data;
- (NSInteger)writeWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (NSInteger)writeWithEncoding:(NSStringEncoding)encoding format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);
- (NSInteger)writeWithFormat:(NSString *)format arguments:(va_list)args NS_FORMAT_FUNCTION(1, 0);
- (NSInteger)writeWithEncoding:(NSStringEncoding)encoding format:(NSString *)format arguments:(va_list)args NS_FORMAT_FUNCTION(2, 0);

@end
