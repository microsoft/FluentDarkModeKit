//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>
#ifdef SWIFT_PACKAGE
#import "DMTraitCollection.h"
#else
#import <FluentDarkModeKit/DMTraitCollection.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class DMDynamicColor;

@interface UIView (DarkModeKit) <DMTraitEnvironment>

+ (void)dm_swizzleSetBackgroundColor;
+ (void)dm_swizzleSetTintColor;
+ (void)dm_swizzleTraitCollectionDidChange;

@property (nonatomic, copy, nullable) DMDynamicColor *dm_dynamicBackgroundColor;

- (void)dm_updateDynamicColors;
- (void)dm_updateDynamicImages;

@end

NS_ASSUME_NONNULL_END
