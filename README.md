# Async
Async流程控制，支持oc链式语法    
Syntactic sugar in Obj-C for asynchronous dispatches in Grand Central Dispatch


# CocoaPods
    platform :ios, '8.0'
    pod 'OCAsync'


# Usage
Chain as many blocks as you want:

    #import <OCAsync/Async.h>

    Async *async = [[Async alloc]init];

    async.userInitiated(0, ^{    // 第一个参数是延时执行时间，单位秒
        // 1
    }).main(0, ^{
        // 2
    }).background(0, ^{
        // 3
    }).main(0, ^ {
        // 4
    });
    
