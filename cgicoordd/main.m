//
//  main.m
//  cgicoordd
//
//  Created by Maxthon Chan on 4/4/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <unistd.h>
#import <signal.h>

#import "CGICoordinator.h"

static volatile BOOL keep_alive;

void terminate(int signal)
{
    keep_alive = NO;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Ignore SIGHUP.
        signal(SIGHUP, SIG_IGN);
        
        // Catch SIGINT and SIGTERM
        signal(SIGINT, terminate);
        signal(SIGTERM, terminate);
        
        // Build the coordinator
        CGICoordinator *coordinator = [[CGICoordinator alloc] init];
        
        // Start the listening port
        NSPort *port = [NSPort port];
        NSPortNameServer *ns = [NSPortNameServer systemDefaultPortNameServer];
        [ns registerPort:port name:CGIWebCoordinatorPortName];
        
        // Start the listening connection
        NSConnection *conn = [NSConnection connectionWithReceivePort:port sendPort:nil];
        NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
        [conn setRootObject:coordinator];
        [conn addRunLoop:mainRunLoop];
        
        // Run it.
        keep_alive = YES;
        
        while (keep_alive)
            [mainRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
        // Stop listening connection
        [conn removeRunLoop:mainRunLoop];
        [conn invalidate];
        
        // Stop listening port
        [port invalidate];
    }
    return 0;
}

