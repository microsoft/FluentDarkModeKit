//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>
#import <FluentDarkModeKit/DMNamespace.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DarkModeKit)

+ (UIColor *)dm_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor
NS_SWIFT_UNAVAILABLE("Use init(_:light:dark:) instead.");

#if __swift__
+ (UIColor *)dm_namespace:(DMNamespace)namespace
      colorWithLightColor:(UIColor *)lightColor
                darkColor:(UIColor *)darkColor NS_SWIFT_NAME(init(_:light:dark:));
#endif

@end

NS_ASSUME_NONNULL_END
