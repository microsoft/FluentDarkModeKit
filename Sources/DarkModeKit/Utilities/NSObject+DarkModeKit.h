//
//  NSObject+DarkModeKit.h
//  DarkModeKit
//
//  Created by Bei Li on 2019/10/29.
//  Copyright © 2019 Microsoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DarkModeKit)

/// Swizzle two instance methods for class that calls this method.
///
/// Return NO if any selector can not found corresponding method.
+ (BOOL)dm_swizzleInstanceMethod:(SEL)fromSelector to:(SEL)toSelector;

@end

NS_ASSUME_NONNULL_END
