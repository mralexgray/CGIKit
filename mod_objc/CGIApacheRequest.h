//
//  CGIApacheRequest.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <CGIKit/CGIKit.h>
#import <httpd.h>

@interface CGIApacheRequest : CGIHTTPRequest

- (id)initWithApacheRequest:(request_rec *)request;

@end
