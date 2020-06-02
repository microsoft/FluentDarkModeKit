//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIImage+DarkModeKit.h"
#import "DMDynamicImage.h"
#import "NSObject+DarkModeKit.h"

@import ObjectiveC;

@implementation UIImage (DarkModeKit)

+ (void)dm_swizzleIsEqual {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(isEqual:);
    [self dm_swizzleSelector:@selector(isEqual:) withBlock:^id _Nonnull(IMPContainer *container) {
      return ^BOOL (UIImage *self, UIImage *other) {
        /// On iOS 13, UIImage `isEqual:` somehow changes internally and doesn't work for `NSProxy`,
        /// here we forward the message to internal images manually
        UIImage *realSelf = self;
        UIImage *realOther = other;
        if (object_getClass(self) == DMDynamicImageProxy.class) {
          realSelf = ((DMDynamicImageProxy *)self).resolvedImage;
        }
        if (object_getClass(other) == DMDynamicImageProxy.class) {
          realOther = ((DMDynamicImageProxy *)other).resolvedImage;
        }
        return ((BOOL (*)(UIImage *, SEL, UIImage *))container.imp)(realSelf, selector, realOther);
      };
    }];
  });
}

+ (UIImage *)dm_imageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage {
  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:lightImage darkImage:darkImage];
}

+ (UIImage *)dm_namespace:(DMNamespace)namespace
      imageWithLightImage:(UIImage *)lightImage
                darkImage:(UIImage *)darkImage {
  return [UIImage dm_imageWithLightImage:lightImage darkImage:darkImage];
}

@end
