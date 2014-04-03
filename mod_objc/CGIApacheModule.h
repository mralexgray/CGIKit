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

extern void *CGIServerConfigurationCreate(apr_pool_t *p, server_rec *s);
extern void *CGIServerConfigurationMerge(apr_pool_t *p, void *base_conf, void *new_conf);
extern void *CGIDirectoryConfigurationCreate(apr_pool_t *p, char *dir);
extern void *CGIDirectoryConfigurationMerge(apr_pool_t *p, void *base_conf, void *new_conf);
extern command_rec CGIApacheCommands[];
extern void CGIAddServerHooks(apr_pool_t *p);

@interface CGIApacheModule : NSObject

+ (instancetype)module;

@end


