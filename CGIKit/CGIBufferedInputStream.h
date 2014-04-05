//
//  CGIBufferedInputStream.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIBufferedInputStream : NSInputStream

@property (readonly) NSInputStream *underlyingStream;

- (id)initWithUnderlyingStream:(NSInputStream *)underlyingStream;

- (NSData *)readDataMaxLength:(NSUInteger)length;
- (NSData *)readDataToData:(NSData *)endpoint;

- (NSString *)readLine;
- (NSString *)readLineWithEncoding:(NSStringEncoding)encoding;

@end

NSData *CGICarriageReturn(void);
NSData *CGILineFeed(void);
NSData *CGICarriageReturnLineFeed(void);
NSData *CGISpace(void);
NSData *CGINull(void);
