//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIView+DarkModeKit.h"
#import "UIView+DarkModeKitSwizzling.h"
#import "DMDynamicColor.h"

@import ObjectiveC;

@implementation UIView (DarkModeKit)

// MARK: - Trait Collection
- (DMTraitCollection *)dmTraitCollection {
  if (@available(iOS 13.0, *)) {
    return [DMTraitCollection traitCollectionWithUITraitCollection:self.traitCollection];
  }
  return DMTraitCollection.overrideTraitCollection;
}

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
  if (@available(iOS 13.0, *)) {
    return;
  }

  [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
    [view dmTraitCollectionDidChange:previousTraitCollection];
  }];
  [self setNeedsLayout];
  [self setNeedsDisplay];
  [self dm_updateDynamicColors];
  [self dm_updateDynamicImages];
}

// MARK: - Legacy Support
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
