//
//  UIActionSheet+BlocksKit.m
//  BlocksKit
//

#import "UIActionSheet+BlocksKit.h"
#import "NSObject+AssociatedObjects.h"

@interface UIActionSheet (BlocksKitPrivate)
@property (nonatomic, retain) NSMutableDictionary *blocks;
@end

@implementation UIActionSheet (BlocksKit)

static char kActionSheetBlockDictionaryKey; 
static NSString *kActionSheetCancelBlockKey = @"UIActionSheetCancelBlock";


+ (id)sheetWithTitle:(NSString *)title {
    return [[[UIActionSheet alloc] initWithTitle:title] autorelease];
}

- (id)initWithTitle:(NSString *)title {
    return [self initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
}

- (void)addButtonWithTitle:(NSString *)title handler:(BKBlock) block {
    NSAssert(title.length, @"A button without a title cannot be added to the action sheet.");
    NSInteger index = [self addButtonWithTitle:title];
    [self.blocks setObject:(block ? [[block copy] autorelease] : [NSNull null]) forKey:[NSNumber numberWithInteger:index]];
}

- (void)setDestructiveButtonWithTitle:(NSString *) title handler:(BKBlock) block {
    NSAssert(title.length, @"A button without a title cannot be added to the action sheet.");
    NSInteger index = [self addButtonWithTitle:title];
    [self.blocks setObject:(block ? [[block copy] autorelease] : [NSNull null]) forKey:[NSNumber numberWithInteger:index]];
    self.destructiveButtonIndex = index;
}

- (void)setCancelButtonWithTitle:(NSString *)title handler:(BKBlock)block {
    NSInteger index = -1;
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && !title)
        title = NSLocalizedString(@"Cancel", nil);
    if (title)
        index = [self addButtonWithTitle:title];
    [self.blocks setObject:(block ? [[block copy] autorelease] : [NSNull null]) forKey:kActionSheetCancelBlockKey];
    self.cancelButtonIndex = index;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSMutableDictionary *blocks = self.blocks;
    
    __block BKBlock actionBlock = nil;
    
    if (buttonIndex == self.cancelButtonIndex)
        actionBlock = [blocks objectForKey:kActionSheetCancelBlockKey];
    else
        actionBlock = [blocks objectForKey:[NSNumber numberWithInteger:buttonIndex]];
    
    if (actionBlock && (![actionBlock isEqual:[NSNull null]]))
        dispatch_async(dispatch_get_main_queue(), actionBlock);
    
    self.blocks = nil;
}

- (NSMutableDictionary *)blocks {
    NSMutableDictionary *blocks = [self associatedValueForKey:&kActionSheetBlockDictionaryKey];
    if (!blocks) {
        blocks = [[NSMutableDictionary alloc] init];
        self.blocks = blocks;
        [blocks release];
    }
    return blocks;
}

- (void)setBlocks:(NSMutableDictionary *)blocks {
    [self associateValue:blocks withKey:&kActionSheetBlockDictionaryKey];
}

@end
