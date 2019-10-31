//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DynamicColor)
@interface DMDynamicColor : UIColor

@property (nonatomic, readonly) UIColor *lightColor;
@property (nonatomic, readonly) UIColor *darkColor;

- (instancetype)initWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
