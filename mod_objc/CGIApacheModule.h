//
//  CGIApacheModule.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <httpd.h>
#import <http_config.h>

extern void CGIAddServerHooks(apr_pool_t *p);

@interface CGIApacheModule : NSObject

- (int)handleRequest:(request_rec *)req;

@end


