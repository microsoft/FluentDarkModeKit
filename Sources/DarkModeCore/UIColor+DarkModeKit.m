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

@end
