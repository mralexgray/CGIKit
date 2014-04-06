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
#import "CGIServer.h"

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

volatile BOOL keep_alive;

int main(int argc, char *const *argv)
{

    @autoreleasepool {
        
        // Kill SIGHUP
        signal(SIGHUP, SIG_IGN);
        
        NSString *listen = nil;
        NSInteger port = -1;
        
        CGIVirtualHost *currentVirtualHost = nil;
        NSMutableArray *virtualHosts = [NSMutableArray array];
        
        char ch = 0;
        while ((ch = getopt_long(argc, argv, "p:l:r:v:hV", options, NULL)) != -1)
        {
            tprintf(@"argument: -%c, parameter (may be junk): %s\n", ch, optarg ?: "(null)");
            switch (ch)
            {
                case 'p':
                    if (port < 0)
                    {
                        if (!sscanf(optarg, "%lu", &port))
                            fprintf(stderr, "warning: bad port number ignored: %s\n", optarg);
                    }
                    else
                        fprintf(stderr, "warning: duplicated port number ignored: %s\n", optarg);
                    break;
                case 'l':
                    if (!listen)
                        listen = @(optarg);
                    else
                        fprintf(stderr, "warning: duplicated listen address ignored: %s\n", optarg);
                    break;
                case 'r':
                    if (!currentVirtualHost)
                        currentVirtualHost = [[CGIVirtualHost alloc] init];
                    
                    if (!currentVirtualHost.serverRoot)
                        currentVirtualHost.serverRoot = [@(optarg) stringByExpandingTildeInPath];
                    else
                    {
                        if (currentVirtualHost.hostName)
                            fprintf(stderr, "warning: duplicated root directory for virtual host %s ignored: %s\n",
                                    [currentVirtualHost.hostName UTF8String],
                                    optarg);
                        else
                            fprintf(stderr, "warning: duplicated root directory ignored: %s\n", optarg);
                    }
                    break;
                case 'v':
                    if (currentVirtualHost)
                    {
                        if (currentVirtualHost.serverRoot)
                            [virtualHosts addObject:currentVirtualHost];
                        else if (currentVirtualHost.hostName)
                            fprintf(stderr, "warning: empty named virtual host %s overridden.\n", [currentVirtualHost.hostName UTF8String]);
                    }
                    
                    currentVirtualHost = [[CGIVirtualHost alloc] init];
                    currentVirtualHost.hostName = @(optarg);
                    break;
                case 'h':
                case 'V':
                    exit(EXIT_SUCCESS);
                    break;
                case '?':
                default:
                    exit(EXIT_FAILURE);
                    break;
            }
        }
        
        if (port < 0)
            port = getuid() ? 8080 : 80;
        
        if (getuid() && port < 1024)
        {
            fprintf(stderr, "error: cannot open port %lu without root.\n", port);
            exit(EXIT_FAILURE);
        }
        
        if (currentVirtualHost.serverRoot)
            [virtualHosts addObject:currentVirtualHost];
        
        if (![virtualHosts count])
        {
            fprintf(stderr, "error: no hosts, virtual or not, defined.\n");
            exit(EXIT_FAILURE);
        }
        
        fprintf(stderr, "info: starting %lu hosts on %s port %lu.\n", [virtualHosts count], listen ? [listen UTF8String] : "(default)", port);
        
        CGIServer *server = [[CGIServer alloc] initOnHost:listen port:port virtualHosts:virtualHosts];
        
        if (!server)
        {
            fprintf(stderr, "error: cannot initialize server: %s\n", strerror(errno));
            exit(EXIT_FAILURE);
        }
        
        keep_alive = YES;
        
        NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
        [server addToRunLoop:mainRunLoop];
        
        while (keep_alive)
        {
            [mainRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        [server removeFromRunLoop:mainRunLoop];
    }
    return 0;
}

