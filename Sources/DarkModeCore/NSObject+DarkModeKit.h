//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DarkModeKit)

/// Swizzle two instance methods for class that calls this method.
///
/// Return NO if any selector cannot find corresponding method.
+ (BOOL)dm_swizzleInstanceMethod:(SEL)fromSelector to:(SEL)toSelector;

@end

NS_ASSUME_NONNULL_END
