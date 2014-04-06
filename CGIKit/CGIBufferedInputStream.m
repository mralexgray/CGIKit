//
//  CGIBufferedInputStream.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIBufferedInputStream.h"

@implementation CGIBufferedInputStream
{
    NSInputStream *_underlyingStream;
    NSMutableData *_buffer;
}

@synthesize underlyingStream = _underlyingStream;

- (id)initWithUnderlyingStream:(NSInputStream *)underlyingStream
{
    if (self = [super init])
    {
        if ([_underlyingStream isKindOfClass:[self class]])
        {
            self = nil;
            return (CGIBufferedInputStream *)_underlyingStream;
        }
        
        if (underlyingStream)
            _underlyingStream = underlyingStream;
        else
            return self = nil;
        
        _buffer = [NSMutableData data];
    }
    return self;
}

- (id)initWithData:(NSData *)data
{
    return [self initWithUnderlyingStream:[[NSInputStream alloc] initWithData:data]];
}

- (id)initWithFileAtPath:(NSString *)path
{
    return [self initWithUnderlyingStream:[[NSInputStream alloc] initWithFileAtPath:path]];
}

- (id)initWithURL:(NSURL *)url
{
    return [self initWithUnderlyingStream:[[NSInputStream alloc] initWithURL:url]];
}

- (BOOL)hasBytesAvailable
{
    if ([_buffer length])
        return YES;
    else
        return [_underlyingStream hasBytesAvailable];
}

- (NSUInteger)fillBufferToLength:(NSUInteger)len
{
    if ([_buffer length] < len)
    {
        NSUInteger difference = len - [_buffer length];
        uint8_t *inc = malloc(difference);
        if (!inc)
            return 0;
        
        NSInteger actuallyRead = [_underlyingStream read:inc maxLength:difference];
        [_buffer appendBytes:inc length:actuallyRead];
        
        free(inc);
    }
    return [_buffer length];
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    // Fill buffer until either data is depleted or length requirement s met.
    [self fillBufferToLength:len];
    NSInteger actualLength = MIN(len, [_buffer length]);
    [_buffer getBytes:buffer length:actualLength];
    [_buffer replaceBytesInRange:NSMakeRange(0, actualLength) withBytes:NULL length:0];
    return actualLength;
}

- (NSData *)readDataMaxLength:(NSUInteger)length
{
    [self fillBufferToLength:length];
    NSUInteger actualLength = MIN(length, [_buffer length]);
    NSRange readRage = NSMakeRange(0, actualLength);
    NSData *outputData = [_buffer subdataWithRange:readRage];
    [_buffer replaceBytesInRange:readRage withBytes:NULL length:0];
    return outputData;
}

- (BOOL)increaseBuffer
{
    NSUInteger targetLength = [_buffer length] + 64;
    return [self fillBufferToLength:targetLength] >= targetLength;
}

- (NSData *)readDataToData:(NSData *)endpoint
{
    NSRange dataRange;
    while (((dataRange = [_buffer rangeOfData:endpoint options:0 range:NSMakeRange(0, [_buffer length])]).location == NSNotFound))
    {
        if (![self increaseBuffer])
            break;
    }
    
    NSRange readRange = NSMakeRange(0, (dataRange.location == NSNotFound) ? [_buffer length] : NSMaxRange(dataRange));
    NSData *outputData = [_buffer subdataWithRange:readRange];
    [_buffer replaceBytesInRange:readRange withBytes:NULL length:0];
    
    return outputData;
}

- (NSString *)readLine
{
    return [self readLineWithEncoding:NSUTF8StringEncoding];
}

- (NSString *)readLineWithEncoding:(NSStringEncoding)encoding
{
    NSData *dataPickedUp = [self readDataToData:CGILineFeed()];
    return [[NSString alloc] initWithData:dataPickedUp encoding:encoding];
}

@end

NSData *CGICarriageReturn(void)
{
    return [NSData dataWithBytes:"\r" length:1];
}

NSData *CGILineFeed(void)
{
    return [NSData dataWithBytes:"\n" length:1];
}

NSData *CGICarriageReturnLineFeed(void)
{
    return [NSData dataWithBytes:"\r\n" length:2];
}

NSData *CGISpace(void)
{
    return [NSData dataWithBytes:" " length:1];
}

NSData *CGINull(void)
{
    return [NSData dataWithBytes:"\0" length:1];
}
