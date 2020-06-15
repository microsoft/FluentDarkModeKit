//
//  UIApplication+DarkModeKit.h
//  FluentDarkModeKit
//
//  Created by Levin Li on 2020/6/15.
//  Copyright © 2020 Microsoft Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef SWIFT_PACKAGE
#import "DMTraitCollection.h"
#else
#import <FluentDarkModeKit/DMTraitCollection.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (DarkModeKit) <DMTraitEnvironment>

@end

NS_ASSUME_NONNULL_END
