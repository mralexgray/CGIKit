//
//  CGICommon.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#include "CGICommon.h"

NSString *CGIHTTPAttributeNameFromCGI(NSString *cgiAttributeName)
{
    if ([cgiAttributeName hasPrefix:@"HTTP_"])
        cgiAttributeName = [cgiAttributeName substringFromIndex:5];
    NSMutableArray *parts = [NSMutableArray arrayWithArray:[cgiAttributeName componentsSeparatedByString:@"_"]];
    for (NSUInteger idx = 0; idx < [parts count]; idx++)
    {
        NSString *part = parts[idx];
        parts[idx] = [part capitalizedString];
    }
    
    return [parts componentsJoinedByString:@"-"];
}
