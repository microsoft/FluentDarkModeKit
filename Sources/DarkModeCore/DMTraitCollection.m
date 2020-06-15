//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMTraitCollection.h"
#import "DMDarkModeManager.h"
#import <UIKit/UIKit.h>

@implementation DMTraitCollection

static DMTraitCollection *_currentTraitCollection = nil;

+ (DMTraitCollection *)currentTraitCollection {
  if (@available(iOS 13, *)) {
    if (DMDarkModeManager.interoperableWithUIKit) {
      return (DMTraitCollection *)UITraitCollection.currentTraitCollection;
    }
  }
  
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
