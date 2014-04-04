//
//  CGIApacheOutputStream.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <httpd.h>

@interface CGIApacheOutputStream : NSOutputStream

- (id)initWithApacheRequest:(request_rec *)request;

@end
