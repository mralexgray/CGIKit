//
//  NSScanner+CGIHTTPProtocolHandling.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "NSScanner+CGIHTTPProtocolHandling.h"

#import <objc/runtime.h>

#define CGIScannerAssert(func) if (!func) { [self setScanLocation:[self popState]]; return NO; }

@implementation NSScanner (CGIHTTPProtocolHandling)

- (NSMutableArray *)state
{
    return objc_getAssociatedObject(self, @selector(state));
}

- (void)setState:(NSMutableArray *)state
{
    objc_setAssociatedObject(self, @selector(state), state, OBJC_ASSOCIATION_RETAIN);
}

- (void)pushState
{
    if (![self state])
        [self setState:[NSMutableArray arrayWithObject:@([self scanLocation])]];
    else
        [[self state] addObject:@([self scanLocation])];
}

- (NSUInteger)popState
{
    if ([self state])
    {
        NSUInteger value = [[[self state] lastObject] unsignedIntegerValue];
        [[self state] removeLastObject];
        
        if (![[self state] count])
            [self setState:nil];
        
        return value;
    }
    else
        return NSNotFound;
}

- (BOOL)scanHTTPMethod:(NSString *__autoreleasing *)method URI:(NSString *__autoreleasing *)URI protocolVersion:(NSString *__autoreleasing *)protocolVersion
{
    return NO;
}

@end
