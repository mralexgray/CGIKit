//
//  CGIHTTPContext.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CGIHTTPRequest, CGIHTTPResponse;

@interface CGIHTTPContext : NSObject

@property (readonly) CGIHTTPRequest *request;
@property (readonly) CGIHTTPResponse *response;

@end
