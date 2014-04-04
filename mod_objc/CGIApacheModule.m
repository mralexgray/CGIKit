//
//  CGIApacheModule.m
//  CGIKit
//
//  Created by Maxthon Chan on 4/3/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import "CGIApacheModule.h"

#import "CGIApacheRequest.h"
#import "CGIApacheResponse.h"
#import "CGIApacheServer.h"

#import <CGIServer/CGIServer.h>

#import <httpd.h>
#import <http_log.h>

#import <http_core.h>
#import <http_connection.h>
#import <http_request.h>
#import <http_protocol.h>

@implementation CGIApacheModule

- (int)handleRequest:(request_rec *)req
{
    CGIApacheRequest *request = [[CGIApacheRequest alloc] initWithApacheRequest:req];
    CGIApacheResponse *response = [[CGIApacheResponse alloc] initWithApacheRequest:req];
    CGIApacheServer *server = [[CGIApacheServer alloc] initWithApacheServer:req->server];
    
    // Look for the local coordinator
    NSConnection *conn = [NSConnection connectionWithRegisteredName:CGIWebCoordinatorPortName
                                                               host:nil];
    CGIWebCoordinator *coordinator = (id)[conn rootProxy];
    
    if (!coordinator)
    {
        // We don't have a coordinator. Abort.
        ap_log_rerror(__FILE__, __LINE__, APLOG_ERR, 500, req, "I cannot connect to any instance of cgicoordd (CGIWebCoordinator or its subclasses). Bailing out.\n");
        
        req->status = 500;
        ap_set_content_type(req, "text/html");
        
        ap_rputs("<!DOCTYPE html>\n"
                 "<html>\n"
                 "<head>\n"
                 "<meta charset=\"utf-8\" />\n"
                 "<title>HTTP 500 Internal Server Error</title>\n"
                 "</head>\n"
                 "<body>\n"
                 "<h1>HTTP 500 Internal Server Error</h1>\n"
                 "<p>The following error happened: I cannot connect to any instance of cgicoordd (CGIWebCoordinator or its subclasses).</p>\n"
                 "<hr />\n"
                 "<address><a href=\"https://github.com/xcvista/CGIKit\">CGIKit 7.0</a>, &copy; 2011-2014 Maxthon Chan</address>\n"
                 "</body>\n"
                 "</html>\n",
                 req);
        
        return EXIT_SUCCESS;
    }
    
    return [coordinator handleRequest:request onServer:server withResponse:response];
}

@end

int CGIProcessRequest(request_rec *r)
{
    if (!r->handler || strcmp(r->handler, "wib-handler"))
        return DECLINED;
    
    NSLog(@"Handling Web Interface Builder file %s.", r->uri);
    
    CGIApacheModule *module = [[CGIApacheModule alloc] init];
    return [module handleRequest:r];
}

void CGIAddServerHooks(apr_pool_t *p)
{
    NSLog(@"CGIKit 7.0 initializing.");
    ap_hook_handler(CGIProcessRequest, NULL, NULL, APR_HOOK_LAST);
}


