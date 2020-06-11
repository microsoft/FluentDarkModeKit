//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIColor+DarkModeKit.h"
#import "DMDynamicColor.h"

@implementation UIColor (DarkModeKit)

+ (UIColor *)dm_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
  return (UIColor *)[[DMDynamicColor alloc] initWithLightColor:lightColor darkColor:darkColor];
}

+ (UIColor *)dm_namespace:(DMNamespace)namespace
      colorWithLightColor:(UIColor *)lightColor
                darkColor:(UIColor *)darkColor {
  return [UIColor dm_colorWithLightColor:lightColor darkColor:darkColor];
}

+ (UIColor *)dm_colorWithDynamicProvider:(UIColor *(^)(DMTraitCollection *))dynamicProvider {
  return (UIColor *)[[DMDynamicColor alloc] initWithDynamicProvider:dynamicProvider];
}

+ (UIColor *)dm_namespace:(DMNamespace)namespace dynamicProvider:(UIColor *(^)(DMTraitCollection *))dynamicProvider {
  return [self dm_colorWithDynamicProvider:dynamicProvider];
}

- (UIColor *)dm_resolvedColorWithTraitCollection:(DMTraitCollection *)traitCollection {
  // Here we just need to take care of UIColor that is not DMDynamicColor
  // since DMDynamicColor methods are all forwarded, simply return self
  // before we need to bridge iOS 13's color mechanism
  return self;
}

- (UIColor *)dm_namespace:(DMNamespace)namespace resolvedColorWithTraitCollection:(DMTraitCollection *)traitCollection {
  return [self dm_resolvedColorWithTraitCollection:traitCollection];
}

@end
