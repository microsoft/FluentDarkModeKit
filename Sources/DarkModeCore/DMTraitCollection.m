//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMTraitCollection.h"

@implementation DMTraitCollection

static DMTraitCollection *_currentTraitCollection = nil;

+ (DMTraitCollection *)currentTraitCollection {
  return _currentTraitCollection;
}

+ (void)setCurrentTraitCollection:(DMTraitCollection *)currentTraitCollection {
  _currentTraitCollection = currentTraitCollection;
}

+ (DMTraitCollection *)traitCollectionWithUserInterfaceStyle:(DMUserInterfaceStyle)userInterfaceStyle {
  DMTraitCollection *traitCollection = [[DMTraitCollection alloc] init];
  traitCollection->_userInterfaceStyle = userInterfaceStyle;
  return traitCollection;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _userInterfaceStyle = DMUserInterfaceStyleUnspecified;
  }
  return self;
}

@end
