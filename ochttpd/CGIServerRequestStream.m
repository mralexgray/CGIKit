//
//  CGIServerRequestStream.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIServerRequestStream.h"

#import "CGIServerContext.h"

@implementation CGIServerRequestStream
{
    CGIServerContext *_context;
}

- (id)initWithContext:(CGIServerContext *)context
{
    if (self = [super init])
    {
        _context = context;
    }
    return self;
}

- (BOOL)hasBytesAvailable
{
    return YES;
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    NSData *bytes = [_context readLength:len];
    if (bytes)
    {
        [bytes getBytes:buffer length:MIN(len, [bytes length])];
    }
    return [bytes length];
}

@end
