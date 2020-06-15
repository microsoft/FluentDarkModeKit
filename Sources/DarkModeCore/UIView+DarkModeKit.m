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

+ (void)dm_swizzleSetTintColor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(setTintColor:);
    Method method = class_getInstanceMethod(self, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIView setTintdColor:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(self, selector, imp_implementationWithBlock(^(UIView *self, UIColor *tintColor) {
      if ([tintColor isKindOfClass:[DMDynamicColor class]]) {
        self.dm_dynamicTintColor = (DMDynamicColor *)tintColor;
      }
      else {
        self.dm_dynamicTintColor = nil;
      }
      ((void (*)(UIView *, SEL, UIColor *))imp)(self, selector, tintColor);
    }), method_getTypeEncoding(method));
  });
}

+ (void)dm_swizzleTraitCollectionDidChange {
  if (@available(iOS 13.0, *)) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      SEL selector = @selector(traitCollectionDidChange:);
      Method method = class_getInstanceMethod(self, selector);
      if (!method)
        NSAssert(NO, @"Method not found for [UIView traitCollectionDidChange:]");

      IMP imp = method_getImplementation(method);
      class_replaceMethod(self, selector, imp_implementationWithBlock(^(UIView *self, UITraitCollection *previousTraitCollection) {

        ((void (*)(UIView *, SEL, UITraitCollection *))imp)(self, selector, previousTraitCollection);
      }), method_getTypeEncoding(method));
    });
  }
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

- (DMDynamicColor *)dm_dynamicTintColor {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setDm_dynamicTintColor:(DMDynamicColor *)dm_dynamicTintColor {
  objc_setAssociatedObject(self,
                           @selector(dm_dynamicTintColor),
                           dm_dynamicTintColor,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
  [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
    [view dmTraitCollectionDidChange:previousTraitCollection];
  }];
  [self setNeedsLayout];
  [self setNeedsDisplay];
  [self dm_updateDynamicColors];
  [self dm_updateDynamicImages];
}

- (void)dm_updateDynamicColors {
  UIColor *backgroundColor = [self dm_dynamicBackgroundColor];
  if (backgroundColor) {
    [self setBackgroundColor:backgroundColor];
  }
  UIColor *tintColor = [self dm_dynamicTintColor];
  if (tintColor) {
    [self setTintColor:tintColor];
  }
}

- (void)dm_updateDynamicImages {
  // For subclasses to override.
}

@end
