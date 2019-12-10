//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface DMDynamicImageProxy : NSProxy

@property (nonatomic, readonly) UIImage *resolvedImage;

- (instancetype)initWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage;

@end

NS_ASSUME_NONNULL_END
