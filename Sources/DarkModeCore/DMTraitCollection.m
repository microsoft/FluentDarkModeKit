//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMTraitCollection.h"
#import <UIKit/UITraitCollection.h>

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

+ (DMTraitCollection *)traitCollectionWithUITraitCollection:(UITraitCollection *)traitCollection {
  DMUserInterfaceStyle style = DMUserInterfaceStyleUnspecified;
  switch (traitCollection.userInterfaceStyle) {
    case UIUserInterfaceStyleLight:
      style = DMUserInterfaceStyleLight;
      break;
    case UIUserInterfaceStyleDark:
      style = DMUserInterfaceStyleDark;
      break;
    case UIUserInterfaceStyleUnspecified:
    default:
      style = DMUserInterfaceStyleUnspecified;
      break;
  }
  return [self traitCollectionWithUserInterfaceStyle:style];
}

- (UITraitCollection *)uiTraitCollection {
  UIUserInterfaceStyle style = UIUserInterfaceStyleUnspecified;
  switch (_userInterfaceStyle) {
    case DMUserInterfaceStyleLight:
      style = UIUserInterfaceStyleLight;
      break;
    case DMUserInterfaceStyleDark:
      style = UIUserInterfaceStyleDark;
      break;
    case DMUserInterfaceStyleUnspecified:
    default:
      style = UIUserInterfaceStyleUnspecified;
      break;
  }
  return [UITraitCollection traitCollectionWithUserInterfaceStyle:style];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _userInterfaceStyle = DMUserInterfaceStyleUnspecified;
  }
  return self;
}

@end
