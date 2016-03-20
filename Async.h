//
//  Async.h
//  Async
//
//  Created by shenhai on 16/3/21.
//  Copyright © 2016年 Innotech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Async;


typedef Async* (^AsyncMethod)(double after, dispatch_block_t chainingBlock);
typedef Async* (^AsyncCustomQueue)(dispatch_queue_t queue, double after, dispatch_block_t chainingBlock);


@interface Async : NSObject

@property (nonatomic, readonly)AsyncMethod main;
@property (nonatomic, readonly)AsyncMethod userInteractive;
@property (nonatomic, readonly)AsyncMethod userInitiated;
@property (nonatomic, readonly)AsyncMethod utility;
@property (nonatomic, readonly)AsyncMethod background;
@property (nonatomic, readonly)AsyncCustomQueue customQueue;


@end