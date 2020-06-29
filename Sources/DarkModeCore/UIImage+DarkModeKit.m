//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIImage+DarkModeKit.h"
#import "DMDynamicImage.h"
#import "DMTraitCollection.h"

@import ObjectiveC;

@implementation UIImage (DarkModeKit)

+ (void)dm_swizzleIsEqual {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(isEqual:);
    Method method = class_getInstanceMethod(self, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIImage isEqual:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(self, selector, imp_implementationWithBlock(^BOOL(UIImage *self, UIImage *other) {
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
      return ((BOOL(*)(UIImage *, SEL, UIImage *))imp)(realSelf, selector, realOther);
    }), method_getTypeEncoding(method));
  });
}

+ (UIImage *)dm_imageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage {
  if (@available(iOS 13, *)) {
    UITraitCollection *lightTraitCollection = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight];
    UITraitCollection *darkTraitCollection = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark];

    UIImageAsset *imageAsset = [[UIImageAsset alloc] init];
    [imageAsset registerImage:lightImage withTraitCollection:lightTraitCollection];
    [imageAsset registerImage:darkImage withTraitCollection:darkTraitCollection];

    return [imageAsset imageWithTraitCollection:DMTraitCollection.overrideTraitCollection.uiTraitCollection];
  }

  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:lightImage darkImage:darkImage];
}

+ (UIImage *)dm_namespace:(DMNamespace)namespace
      imageWithLightImage:(UIImage *)lightImage
                darkImage:(UIImage *)darkImage {
  return [UIImage dm_imageWithLightImage:lightImage darkImage:darkImage];
}

@end
