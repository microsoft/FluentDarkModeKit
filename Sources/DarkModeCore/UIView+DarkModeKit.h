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

- (void)dm_updateDynamicColors API_DEPRECATED("dm_updateDynamicColors is deprecated and will not be called on iOS 13.0+, use dmTraitCollectionDidChange:", ios(11.0, 13.0));;
- (void)dm_updateDynamicImages API_DEPRECATED("dm_updateDynamicImages is deprecated and will not be called on iOS 13.0+, use dmTraitCollectionDidChange:", ios(11.0, 13.0));;

@end

NS_ASSUME_NONNULL_END
