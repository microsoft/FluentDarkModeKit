//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <DarkModeKit/DMTraitCollection.h>

NS_ASSUME_NONNULL_BEGIN

@class DMDynamicColor;

@interface UIView (DarkModeKit) <DMTraitEnvironment>

+ (void)dm_swizzleSetBackgroundColor;

@property (nonatomic, copy, nullable) DMDynamicColor *dm_dynamicBackgroundColor;
@property (nonatomic, copy, nullable) DMDynamicColor *dm_dynamicTintColor;

- (void)dm_updateDynamicColors;
- (void)dm_updateDynamicImages;

@end

NS_ASSUME_NONNULL_END
