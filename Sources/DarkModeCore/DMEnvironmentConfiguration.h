//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMEnvironmentConfiguration : NSObject

@property (nonatomic) BOOL useImageAsset API_AVAILABLE(ios(13.0)); // Defaults to NO
@property (nullable, nonatomic) void (^themeChangeHandler)(void); // Defaults to nil
@property (nullable, nonatomic) void (^windowThemeChangeHandler)(UIWindow *) API_AVAILABLE(ios(13.0)); // Defaults to nil

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
