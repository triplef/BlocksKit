//
//  NSDictionary+BlocksKit.m
//  BlocksKit
//

#import "NSDictionary+BlocksKit.h"
#import <dispatch/dispatch.h>

@implementation NSDictionary (BlocksKit)

- (void)each:(BKKeyValueBlock)block {
    __block BKKeyValueBlock theBlock = block;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        dispatch_async(dispatch_get_main_queue(), ^{ theBlock(key, obj); });
    }];
}

- (NSDictionary *)map:(BKKeyValueTransformBlock)block {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    
    __block BKKeyValueTransformBlock theBlock = block;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [dictionary setObject:theBlock(key, obj) forKey:key];
    }];
    
    NSDictionary *result = [dictionary copy];
    [dictionary release];
    return [result autorelease];
}

@end
