//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>

@class UITraitCollection;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DMUserInterfaceStyle) {
  DMUserInterfaceStyleUnspecified,
  DMUserInterfaceStyleLight,
  DMUserInterfaceStyleDark,
};

@interface DMTraitCollection : NSObject

@property (class, nonatomic, readonly) DMTraitCollection *currentTraitCollection;
@property (class, nonatomic, readonly) DMTraitCollection *lastManuallySetTraitCollection;

+ (DMTraitCollection *)traitCollectionWithUserInterfaceStyle:(DMUserInterfaceStyle)userInterfaceStyle;
+ (DMTraitCollection *)traitCollectionWithUITraitCollection:(UITraitCollection *)traitCollection API_AVAILABLE(ios(13.0));

@property (nonatomic, readonly) DMUserInterfaceStyle userInterfaceStyle;
@property (nonatomic, readonly) UITraitCollection *uiTraitCollection API_AVAILABLE(ios(13.0));

- (instancetype)init NS_DESIGNATED_INITIALIZER;

+ (void)registerApplication:(nullable UIApplication *)application;
+ (void)setCurrentTraitCollection:(DMTraitCollection *)currentTraitCollection animated:(BOOL)animated;
+ (void)swizzleUIScreenTraitCollectionDidChange API_AVAILABLE(ios(13.0));

@end

#pragma mark - DMTraitEnvironment

@protocol DMTraitEnvironment <NSObject>

- (void)dmTraitCollectionDidChange:(nullable DMTraitCollection *)previousTraitCollection;

@end

@interface NSObject (DMTraitEnvironment)

+ (void)swizzleTraitCollectionDidChangeToDMTraitCollectionDidChange API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
