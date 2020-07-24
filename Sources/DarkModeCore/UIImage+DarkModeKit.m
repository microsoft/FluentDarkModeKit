//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIImage+DarkModeKit.h"
#import "UIImage+DarkModeKitSwizzling.h"
#import "DMDynamicImage.h"
#import "DMTraitCollection.h"

@import ObjectiveC;

@implementation UIImage (DarkModeKit)

+ (UIImage *)dm_imageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage {
  if (@available(iOS 13, *)) {
    if ([UIImage useUIImageAsset]) {
      UIImageAsset *imageAsset = [[UIImageAsset alloc] init];

      // Always specify a displayScale otherwise a default of 1.0 is assigned
      [imageAsset registerImage:lightImage withTraitCollection:[UITraitCollection traitCollectionWithTraitsFromCollections:@[
        [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight],
        [UITraitCollection traitCollectionWithDisplayScale:lightImage.scale]
      ]]];
      [imageAsset registerImage:darkImage withTraitCollection:[UITraitCollection traitCollectionWithTraitsFromCollections:@[
        [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark],
        [UITraitCollection traitCollectionWithDisplayScale:darkImage.scale]
      ]]];

      return [imageAsset imageWithTraitCollection:DMTraitCollection.overrideTraitCollection.uiTraitCollection];
    }
  }

  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:lightImage darkImage:darkImage];
}

+ (UIImage *)dm_namespace:(DMNamespace)namespace
      imageWithLightImage:(UIImage *)lightImage
                darkImage:(UIImage *)darkImage {
  return [UIImage dm_imageWithLightImage:lightImage darkImage:darkImage];
}

@end
