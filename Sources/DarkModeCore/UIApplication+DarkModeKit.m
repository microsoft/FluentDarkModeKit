//
//  UIApplication+DarkModeKit.m
//  FluentDarkModeKit
//
//  Created by Levin Li on 2020/6/15.
//  Copyright © 2020 Microsoft Corporation. All rights reserved.
//

#import "UIApplication+DarkModeKit.h"
#import "UIView+DarkModeKit.h"

@implementation UIApplication (DarkModeKit)

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
  if (@available(iOS 13.0, *)) {
    return;
  }

  [[self windows] enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
    [window dmTraitCollectionDidChange:previousTraitCollection];
  }];
}

@end
