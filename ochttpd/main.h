//
//  main.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#ifndef CGIKit_main_h
#define CGIKit_main_h

#import <Foundation/Foundation.h>

extern volatile BOOL keep_alive;

#if DEBUG
#define trace() fprintf(stderr, "debug: %s:%u: trace\n", __FILE__, __LINE__)
#define tprintf(fmt, ...) fprintf(stderr, "debug: %s:%u: %s", __FILE__, __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define trace()
#define tprintf(fmt, ...)
#endif

#endif
