//
//  Copyright 2013-2019 Microsoft Inc.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DMUserInterfaceStyle)
{
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

NS_ASSUME_NONNULL_END
