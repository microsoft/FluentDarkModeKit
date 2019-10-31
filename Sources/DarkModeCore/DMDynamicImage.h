//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface DMDynamicImageProxy : NSProxy
@end

@interface UIImage (DynamicImage)

- (instancetype)initWithLightImage:(nullable UIImage *)lightImage darkImage:(nullable UIImage *)darkImage;

- (BOOL)outlookIsEqual:(nullable UIImage *)other;

@end

NS_ASSUME_NONNULL_END
