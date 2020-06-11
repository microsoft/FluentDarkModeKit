//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>
#ifdef SWIFT_PACKAGE
#import "DMNamespace.h"
#import "DMTraitCollection.h"
#else
#import <FluentDarkModeKit/DMNamespace.h>
#import <FluentDarkModeKit/DMTraitCollection.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DarkModeKit)

+ (UIColor *)dm_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor
NS_SWIFT_UNAVAILABLE("Use init(_:light:dark:) instead.");
+ (UIColor *)dm_colorWithDynamicProvider:(UIColor * (^)(DMTraitCollection *traitCollection))dynamicProvider
NS_SWIFT_UNAVAILABLE("Use init(_:dynamicProvider:) instead.");
- (UIColor *)dm_resolvedColorWithTraitCollection:(DMTraitCollection *)traitCollection
NS_SWIFT_UNAVAILABLE("Use resolvedColor(_:with:) instead.");

#if __swift__
+ (UIColor *)dm_namespace:(DMNamespace)namespace
      colorWithLightColor:(UIColor *)lightColor
                darkColor:(UIColor *)darkColor NS_SWIFT_NAME(init(_:light:dark:));
+ (UIColor *)dm_namespace:(DMNamespace)namespace
          dynamicProvider:(UIColor *(^)(DMTraitCollection *traitCollection))dynamicProvider NS_SWIFT_NAME(init(_:dynamicProvider:));
- (UIColor *)dm_namespace:(DMNamespace)namespace resolvedColorWithTraitCollection:(DMTraitCollection *)traitCollection NS_SWIFT_NAME(resolvedColor(_:with:));
#endif

@end

NS_ASSUME_NONNULL_END
