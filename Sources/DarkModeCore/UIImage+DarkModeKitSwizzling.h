//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DarkModeKitSwizzling)

@property (class, readonly) BOOL useUIImageAsset;

+ (void)dm_swizzleIsEqual;

@end

NS_ASSUME_NONNULL_END
