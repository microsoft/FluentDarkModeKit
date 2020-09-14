//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIViewController+DarkModeKit.h"
#import "UIView+DarkModeKit.h"

@import ObjectiveC;

@implementation UIViewController (DarkModeKit)

- (DMTraitCollection *)dmTraitCollection {
  if (@available(iOS 13, *)) {
    return [DMTraitCollection traitCollectionWithUITraitCollection:self.traitCollection];
  }
  return DMTraitCollection.overrideTraitCollection;
}

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
  if (@available(iOS 13, *))
    return;

  [self setNeedsStatusBarAppearanceUpdate];
  [[self presentedViewController] dmTraitCollectionDidChange:previousTraitCollection];
  [[self childViewControllers] enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull child, NSUInteger idx, BOOL * _Nonnull stop) {
    [child dmTraitCollectionDidChange:previousTraitCollection];
  }];
  if ([self isViewLoaded])
    [[self view] dmTraitCollectionDidChange:previousTraitCollection];
}

@end
