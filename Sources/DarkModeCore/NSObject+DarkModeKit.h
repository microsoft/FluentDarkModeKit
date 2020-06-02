//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMPContainer : NSObject

@property (readonly) IMP imp;

@end

@interface NSObject (DarkModeKit)

/// Swizzle an instance method with a block.
/// Return NO if any selector cannot find corresponding method.
///
/// @param selector The selector that needs to be swizzled
/// @param implementationCreationBlock A block that takes in IMPContainer containing original implementation and returns a block with implementation of swizzled implementation
+ (BOOL)dm_swizzleSelector:(SEL)selector withBlock:(id (^)(IMPContainer *))implementationCreationBlock;

@end

NS_ASSUME_NONNULL_END
