//
//  main.m
//  ochttpd
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "main.h"

#import <getopt.h>
#import <unistd.h>

#import "CGIVirtualHost.h"

static struct option options[] =
{
//  { name,         has_arg,            flag,   val },
    { "port",       required_argument,  NULL,   'p' },  // Sets the listening port. Global. Optional, default to 80.
    { "listen",     required_argument,  NULL,   'l' },  // Sets the listening address. Global. Optional, default to [::].
    { "root",       required_argument,  NULL,   'r' },  // Sets the root directory. Per-virtual-host.
    { "vhost",      required_argument,  NULL,   'v' },  // Defines the current virtual host. Optional.
//  { "conf",       required_argument,  NULL,   'c' },  // Read a configuration file. Overriding. Optional.
    { "help",       no_argument,        NULL,   'h' },  // Prints the usage information. Overriding. Optional.
    { "version",    no_argument,        NULL,   'V' },  // Prints the version information. Overriding. Optional.
    { NULL,         0,                  NULL,   0   }
};

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSString *listen = nil;
        NSInteger port = -1;
        
        CGIVirtualHost *currentVirtualHost = nil;
        NSMutableArray *virtualHosts = [NSMutableArray array];
        
        char ch = 0;
        while ((ch = getopt_long(argc, argv, "p:l:r:v:hV", options, NULL)))
        {
            
        }
    }
    return 0;
}

