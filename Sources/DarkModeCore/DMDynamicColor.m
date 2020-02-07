//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMDynamicColor.h"
#import "DMTraitCollection.h"

@interface DMDynamicColorProxy : NSProxy <NSCopying>

@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, strong) UIColor *darkColor;

@property (nonatomic, readonly) UIColor *resolvedColor;

@end

@implementation DMDynamicColorProxy

// TODO: We need a more generic initializer.
- (instancetype)initWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
  self.lightColor = lightColor;
  self.darkColor = darkColor;

  return self;
}

- (UIColor *)resolvedColor {
  if (DMTraitCollection.currentTraitCollection.userInterfaceStyle == DMUserInterfaceStyleDark) {
    return self.darkColor;
  } else {
    return self.lightColor;
  }
}

// MARK: UIColor

- (UIColor *)colorWithAlphaComponent:(CGFloat)alpha {
  return [[DMDynamicColor alloc] initWithLightColor:[self.lightColor colorWithAlphaComponent:alpha]
                                          darkColor:[self.darkColor colorWithAlphaComponent:alpha]];
}

// MARK: NSProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  return [self.resolvedColor methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  [invocation invokeWithTarget:self.resolvedColor];
}

// MARK: NSObject

- (BOOL)isKindOfClass:(Class)aClass {
  static DMDynamicColor *dynamicColor = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dynamicColor = [[DMDynamicColor alloc] init];
  });
  return [dynamicColor isKindOfClass:aClass];
}

// MARK: NSCopying

- (id)copy {
  return [self copyWithZone:nil];
}

- (id)copyWithZone:(NSZone *)zone {
  return [[DMDynamicColorProxy alloc] initWithLightColor:self.lightColor darkColor:self.darkColor];
}

@end

// MARK: -

@implementation DMDynamicColor

- (UIColor *)initWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
  return (DMDynamicColor *)[[DMDynamicColorProxy alloc] initWithLightColor:lightColor darkColor:darkColor];
}

- (UIColor *)lightColor {
  NSAssert(NO, @"This should never be called");
  return nil;
}

- (UIColor *)darkColor {
  NSAssert(NO, @"This should never be called");
  return nil;
}

@end
