//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMDarkModeManager.h"

static BOOL _interoperableWithUIKit;

@implementation DMDarkModeManager

+ (BOOL)interoperableWithUIKit {
  return _interoperableWithUIKit;
}

+ (void)setInteroperableWithUIKit:(BOOL)interoperableWithUIKit {
  _interoperableWithUIKit = interoperableWithUIKit;
}

@end
