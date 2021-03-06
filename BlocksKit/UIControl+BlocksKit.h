//
//  UIControl+BlocksKit.h
//  BlocksKit
//

/** Block control event handling for UIControl.

 This set of extensions allows for block: simply
 add it using -addEventHandler:forControlEvents: and go!

 @warning UIControl is only available on iOS or in a Mac app using Chameleon.

 Includes code by the following:

 - Kevin O'Neill.  <https://github.com/kevinoneill>. 2011. BSD.
 - Zach Waldowski. <https://github.com/zwaldowski>.  2011. MIT.
 */
@interface UIControl (BlocksKit)

///-----------------------------------
/// @name Block event handling
///-----------------------------------

/** Adds a block for a particular event to an internal dispatch table.

 @param handler A block representing an action message, with an argument for the sender.
 @param controlEvents A bitmask specifying the control events for which the action message is sent.
 @see removeEventHandlersForControlEvents:
 */
- (void)addEventHandler:(BKSenderBlock)handler forControlEvents:(UIControlEvents)controlEvents;

/** Removes all blocks for a particular event combination.
 @param controlEvents A bitmask specifying the control events for which the block will be removed.
 @see addEventHandler:forControlEvents:
 */
- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;

@end
