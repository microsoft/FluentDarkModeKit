//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#ifdef SWIFT_PACKAGE
#import "DMTraitCollection.h"
#else
#import <FluentDarkModeKit/DMTraitCollection.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface DMTraitCollection (DarkModeKitSwizzling)

+ (void)setupEnvironmentWithConfiguration:(DMEnvironmentConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
