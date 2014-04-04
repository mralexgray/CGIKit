//
//  CGIVirtualHost.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <CGIKit/CGIKit.h>

@interface CGIVirtualHost : CGIHTTPServer

@property NSString *hostName;
@property NSString *serverRoot;

@end
