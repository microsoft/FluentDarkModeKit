//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMEnvironmentConfiguration.h"

@implementation DMEnvironmentConfiguration

- (instancetype)init {
  self = [super init];
  if (self) {
    _useImageAsset = NO;
  }
  return self;
}

@end
