//
//  Async.m
//  Async
//
//  Created by shenhai on 16/3/21.
//  Copyright © 2016年 Innotech. All rights reserved.
//

#import "Async.h"


/**
 *  GCD
 */

@interface GCD : NSObject

+ (dispatch_queue_t)mainQueue;
+ (dispatch_queue_t)userInteractiveQueue;
+ (dispatch_queue_t)userInitiatedQueue;
+ (dispatch_queue_t)utilityQueue;
+ (dispatch_queue_t)backgroundQueue;

@end

@implementation GCD

+ (dispatch_queue_t)mainQueue {
    return dispatch_get_main_queue();
}

+ (dispatch_queue_t)userInteractiveQueue {
    return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
}

+ (dispatch_queue_t)userInitiatedQueue {
    return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
}

+ (dispatch_queue_t)utilityQueue {
    return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
}

+ (dispatch_queue_t)backgroundQueue {
    return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
}

@end



/**
 *  Async
 */
@interface Async ()

@property (copy, nonatomic)dispatch_block_t block;


@property (nonatomic)AsyncMethod main;
@property (nonatomic)AsyncMethod userInteractive;
@property (nonatomic)AsyncMethod userInitiated;
@property (nonatomic)AsyncMethod utility;
@property (nonatomic)AsyncMethod background;
@property (nonatomic)AsyncCustomQueue customQueue;


+ (Async *)block:(dispatch_block_t)block;

@end



@implementation Async

- (instancetype)init
{
    self = [super init];
    if (self) {
        _block = dispatch_block_create(0, ^{});
    }
    return self;
}

+ (Async *)block:(dispatch_block_t)block {
    Async *async = [[Async alloc]init];
    async.block = block;
    return async;
}


// MARK: - Instance methods (matches static ones)

- (AsyncMethod)main {
    return ^(double after, dispatch_block_t chainingBlock) {
        return [self chain:after chainingBlock:chainingBlock queue:[GCD mainQueue]];
    };
}

- (AsyncMethod)userInteractive {
    return ^(double after, dispatch_block_t chainingBlock) {
        return [self chain:after chainingBlock:chainingBlock queue:[GCD userInteractiveQueue]];
    };
}

- (AsyncMethod)userInitiated {
    return ^(double after, dispatch_block_t chainingBlock) {
        return [self chain:after chainingBlock:chainingBlock queue:[GCD userInitiatedQueue]];
    };
}

- (AsyncMethod)utility {
    return ^(double after, dispatch_block_t chainingBlock) {
        return [self chain:after chainingBlock:chainingBlock queue:[GCD utilityQueue]];
    };
}

- (AsyncMethod)background {
    return ^(double after, dispatch_block_t chainingBlock) {
        return [self chain:after chainingBlock:chainingBlock queue:[GCD backgroundQueue]];
    };
}

- (AsyncCustomQueue)customQueue {
    return ^(dispatch_queue_t queue, double after, dispatch_block_t chainingBlock) {
        return [self chain:after chainingBlock:chainingBlock queue:queue];
    };
}




// MARK: Private instance methods

- (Async *)chain:(double)seconds chainingBlock:(dispatch_block_t)chainingBlock queue:(dispatch_queue_t)queue {
    
    if (seconds) {
        return [self chainAfter:seconds chainingBlock:chainingBlock queue:queue];
    }
    return [self chainNow:chainingBlock queue:queue];
}



- (Async *)chainNow:(dispatch_block_t)chainingBlock queue:(dispatch_queue_t)queue {
    
    dispatch_block_t chainingBlock_t = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock);
    
    dispatch_block_notify(self.block, queue, chainingBlock_t);
    return [Async block:chainingBlock_t];
}



- (Async *)chainAfter:(double)seconds chainingBlock:(dispatch_block_t)chainingBlock queue:(dispatch_queue_t)queue {
    
    dispatch_block_t chainingBlock_t = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock);
    
    dispatch_block_t chainingWrapperBlock = ^() {
        NSInteger nanoSeconds = (NSInteger)(seconds * NSEC_PER_SEC);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds);
        dispatch_after(time, queue, chainingBlock_t);
    };
    
    dispatch_block_t _chainingWrapperBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingWrapperBlock);
    dispatch_block_notify(self.block, queue, _chainingWrapperBlock);
    return [Async block:chainingBlock_t];
}


@end




