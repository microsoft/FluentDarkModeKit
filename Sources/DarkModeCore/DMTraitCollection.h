//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DMUserInterfaceStyle) {
  DMUserInterfaceStyleUnspecified,
  DMUserInterfaceStyleLight,
  DMUserInterfaceStyleDark,
};

@interface DMTraitCollection : NSObject

@property (class, nonatomic, strong) DMTraitCollection *currentTraitCollection;

+ (DMTraitCollection *)traitCollectionWithUserInterfaceStyle:(DMUserInterfaceStyle)userInterfaceStyle;

@property (nonatomic, readonly) DMUserInterfaceStyle userInterfaceStyle;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - DMTraitEnvironment

@protocol DMTraitEnvironment <NSObject>

- (void)dmTraitCollectionDidChange:(nullable DMTraitCollection *)previousTraitCollection;

@end

NS_ASSUME_NONNULL_END
