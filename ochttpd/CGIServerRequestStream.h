//
//  CGIServerRequestStream.h
//  CGIKit
//
//  Created by Maxthon Chan on 4/5/14.
//  Copyright (c) 2014 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIServerRequestStream : NSInputStream

- (id)initWithSocket:(int)socket;

@end
