//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIView+DarkModeKit.h"
#import "DMDynamicColor.h"

@import ObjectiveC;

@implementation UIView (DarkModeKit)

+ (void)dm_swizzleSetBackgroundColor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(setBackgroundColor:);
    Method method = class_getInstanceMethod(self, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIView setBackgroundColor:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(self, selector, imp_implementationWithBlock(^(UIView *self, UIColor *backgroundColor) {
      if ([backgroundColor isKindOfClass:[DMDynamicColor class]]) {
        self.dm_dynamicBackgroundColor = (DMDynamicColor *)backgroundColor;
      }
      else {
        self.dm_dynamicBackgroundColor = nil;
      }
      ((void (*)(UIView *, SEL, UIColor *))imp)(self, selector, backgroundColor);
    }), method_getTypeEncoding(method));
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
