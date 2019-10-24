//
//  Copyright 2013-2019 Microsoft Inc.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface OLMDynamicImageProxy : NSProxy
@end

@interface UIImage (DynamicImage)

- (instancetype)initWithLightImage:(nullable UIImage *)lightImage darkImage:(nullable UIImage *)darkImage;

- (BOOL)outlookIsEqual:(nullable UIImage *)other;

@end

NS_ASSUME_NONNULL_END
