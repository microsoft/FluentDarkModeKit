//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DMDynamicColor;

@interface UIView (DarkModeKitSwizzling)

@property (nullable, readonly) DMDynamicColor *dm_dynamicBackgroundColor;
@property (nullable, readonly) DMDynamicColor *dm_dynamicTintColor;

+ (void)dm_swizzleSetBackgroundColor;
+ (void)dm_swizzleSetTintColor;

@end

NS_ASSUME_NONNULL_END
