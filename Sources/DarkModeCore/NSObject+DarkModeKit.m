//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "NSObject+DarkModeKit.h"

@import ObjectiveC;

@interface IMPContainer ()

@property (readwrite) IMP imp; // Redefine as readwrite so we can set it in this file

@end

@implementation IMPContainer

- (instancetype)init {
  self = [super init];
  if (self) {
    _imp = NULL;
  }
  return self;
}

@end

@implementation NSObject (DarkModeKit)

+ (BOOL)dm_swizzleSelector:(SEL)selector withBlock:(id (^)(IMPContainer *))implementationCreationBlock {
  IMPContainer *container = [IMPContainer new];
  IMP newIMP = imp_implementationWithBlock(implementationCreationBlock(container));
  // Wrap original implementation in an object so it
  // can be retrieved in the swizzled implementation
  container.imp = swizzleSelector(self, selector, newIMP);
  return container.imp != NULL;
}

static IMP swizzleSelector(Class clazz, SEL selector, IMP newImplementation) {
  Method method = class_getInstanceMethod(clazz, selector);
  if (!method)
    return NULL;

  const char *types = method_getTypeEncoding(method);
  // Get current implementation and return in order to call original
  // implementation in swizzling
  IMP previousImplementation = method_getImplementation(method);

  class_replaceMethod(clazz, selector, newImplementation, types);

  return previousImplementation;
}

@end
