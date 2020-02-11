//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DMDynamicColor;

@interface UIView (DarkModeKit)

+ (void)dm_swizzleSetBackgroundColor;

@property (nonatomic, copy, nullable) DMDynamicColor *dm_dynamicBackgroundColor;
@property (nonatomic, copy, nullable) DMDynamicColor *dm_dynamicTintColor;

@end

NS_ASSUME_NONNULL_END
