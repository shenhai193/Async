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

@property (copy, nonatomic, readonly)AsyncMethod main;
@property (copy, nonatomic, readonly)AsyncMethod userInteractive;
@property (copy, nonatomic, readonly)AsyncMethod userInitiated;
@property (copy, nonatomic, readonly)AsyncMethod utility;
@property (copy, nonatomic, readonly)AsyncMethod background;
@property (copy, nonatomic, readonly)AsyncCustomQueue customQueue;


@end