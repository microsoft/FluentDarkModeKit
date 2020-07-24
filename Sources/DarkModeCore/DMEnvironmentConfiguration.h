//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMEnvironmentConfiguration : NSObject

@property (nonatomic) BOOL useImageAsset; // Defaults to NO
@property (nullable, nonatomic) void (^themeChangeHandler)(void); // Defaults to nil

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
