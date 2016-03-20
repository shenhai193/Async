# Async
Async 的oc版本，支持链式语法


Chain as many blocks as you want:

    Async *async = [[Async alloc]init];

    async.userInitiated(0, ^{
        // 1
    }).main(0, ^{
        // 2
    }).background(0, ^{
        // 3
    }).main(0, ^ {
        // 4
    });
