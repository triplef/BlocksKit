//
//  NSTimer+BlocksKit.m
//  BlocksKit
//

#import "NSTimer+BlocksKit.h"

@interface NSTimer (BlocksKitPrivate)
+ (void)_executeBlockFromTimer:(NSTimer *)aTimer;
@end

@implementation NSTimer (BlocksKit)

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(BKBlock)inBlock repeats:(BOOL)inRepeats {
    BKBlock block = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(_executeBlockFromTimer:) userInfo:block repeats:inRepeats];
    [block release];
    return ret;
}

+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(BKBlock)inBlock repeats:(BOOL)inRepeats {
    BKBlock block = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(_executeBlockFromTimer:) userInfo:block repeats:inRepeats];
    [block release];
    return ret;
}

+ (void)_executeBlockFromTimer:(NSTimer *)aTimer {
    __block BKBlock block = [aTimer userInfo];
    if (block) dispatch_sync(dispatch_get_main_queue(), block);
}

@end