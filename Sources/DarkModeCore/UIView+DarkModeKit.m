//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIView+DarkModeKit.h"
#import "DMDynamicColor.h"
#import "NSObject+DarkModeKit.h"

@import ObjectiveC;

@implementation UIView (DarkModeKit)

+ (void)dm_swizzleSetBackgroundColor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(setBackgroundColor:);
    [self dm_swizzleSelector:selector withBlock:^id _Nonnull(IMPContainer * _Nonnull container) {
      return ^(UIView *self, UIColor *backgroundColor) {
        if ([backgroundColor isKindOfClass:[DMDynamicColor class]]) {
          self.dm_dynamicBackgroundColor = (DMDynamicColor *)backgroundColor;
        } else {
          self.dm_dynamicBackgroundColor = nil;
        }
        ((void (*)(UIView *, SEL, UIColor *))container.imp)(self, selector, backgroundColor);
      };
    }];
  });
}

- (DMDynamicColor *)dm_dynamicBackgroundColor {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setDm_dynamicBackgroundColor:(DMDynamicColor *)dm_dynamicBackgroundColor {
  objc_setAssociatedObject(self,
                           @selector(dm_dynamicBackgroundColor),
                           dm_dynamicBackgroundColor,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
