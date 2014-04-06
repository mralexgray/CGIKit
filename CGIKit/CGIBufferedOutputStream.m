//
//  CGIBufferedOutputStream.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIBufferedOutputStream.h"

@implementation CGIBufferedOutputStream
{
    NSOutputStream *_underlyingStream;
}

@synthesize underlyingStream = _underlyingStream;

- (id)initWithUnderlyingStream:(NSOutputStream *)stream
{
    if (self = [super init])
    {
        if ([_underlyingStream isKindOfClass:[self class]])
        {
            self = nil;
            return (CGIBufferedOutputStream *)_underlyingStream;
        }
        
        if (stream)
            _underlyingStream = stream;
        else
            return self = nil;
    }
    return self;
}

- (id)initToBuffer:(uint8_t *)buffer capacity:(NSUInteger)capacity
{
    return [self initWithUnderlyingStream:[[NSOutputStream alloc] initToBuffer:buffer capacity:capacity]];
}

- (id)initToFileAtPath:(NSString *)path append:(BOOL)shouldAppend
{
    return [self initWithUnderlyingStream:[[NSOutputStream alloc] initToFileAtPath:path append:shouldAppend]];
}

- (id)initToMemory
{
    return [self initWithUnderlyingStream:[[NSOutputStream alloc] initToMemory]];
}

- (id)initWithURL:(NSURL *)url append:(BOOL)shouldAppend
{
    return [self initWithUnderlyingStream:[[NSOutputStream alloc] initWithURL:url append:shouldAppend]];
}

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len
{
    return [_underlyingStream write:buffer maxLength:len];
}

- (BOOL)hasSpaceAvailable
{
    return [_underlyingStream hasSpaceAvailable];
}

- (NSInteger)writeData:(NSData *)data
{
    return [self write:[data bytes] maxLength:[data length]];
}

- (NSInteger)writeWithEncoding:(NSStringEncoding)encoding format:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSInteger rv = [self writeWithEncoding:encoding format:format arguments:args];
    va_end(args);
    return rv;
}

- (NSInteger)writeWithEncoding:(NSStringEncoding)encoding format:(NSString *)format arguments:(va_list)args
{
    NSString *writtenString = [[NSString alloc] initWithFormat:format arguments:args];
    NSData *writtenData = [writtenString dataUsingEncoding:encoding];
    return [self writeData:writtenData];
}

- (NSInteger)writeWithFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSInteger rv = [self writeWithEncoding:NSUTF8StringEncoding format:format arguments:args];
    va_end(args);
    return rv;
}

- (NSInteger)writeWithFormat:(NSString *)format arguments:(va_list)args
{
    return [self writeWithEncoding:NSUTF8StringEncoding format:format arguments:args];
}

@end
