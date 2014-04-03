//
//  mod_objc.m
//  mod_objc
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <httpd.h>
#import <http_config.h>
#import "CGIApacheModule.h"

module AP_MODULE_DECLARE_DATA objc_module =
{
    STANDARD20_MODULE_STUFF,
    CGIDirectoryConfigurationCreate,
    CGIDirectoryConfigurationMerge,
    CGIServerConfigurationCreate,
    CGIServerConfigurationMerge,
    NULL,
    CGIAddServerHooks
};
