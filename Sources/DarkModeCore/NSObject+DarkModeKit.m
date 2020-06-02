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

OBJC_EXPORT id objc_msgSendSuper2(struct objc_super *super, SEL op, ...);

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
  // Make sure the class implements the method. If this is not the case, inject an implementation, only calling 'super'.
  // https://gist.github.com/steipete/1d308fad786399b58875cd12e4b9bba2
  class_addMethod(clazz, selector, imp_implementationWithBlock(^(__unsafe_unretained id self, va_list argp) {
      struct objc_super super = {self, clazz};
      return ((id(*)(struct objc_super *, SEL, va_list))objc_msgSendSuper2)(&super, selector, argp);
  }), types);

  return class_replaceMethod(clazz, selector, newImplementation, types);
}

@end
