//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMDynamicColor.h"
#import "DMNamespace.h"

@interface DMDynamicColorProxy : NSProxy <NSCopying>

@property (nonatomic, strong) UIColor *(^dynamicProvider)(DMTraitCollection *);

@property (nonatomic, readonly) UIColor *resolvedColor;

@end

@implementation DMDynamicColorProxy

- (instancetype)initWithDynamicProvider:(UIColor * (^)(DMTraitCollection *traitCollection))dynamicProvider {
  self.dynamicProvider = dynamicProvider;
  return self;
}

- (UIColor *)resolvedColor {
  return [self resolvedColorWithTraitCollection:DMTraitCollection.currentTraitCollection];
}

- (UIColor *)resolvedColorWithTraitCollection:(DMTraitCollection *)traitCollection {
  return self.dynamicProvider(traitCollection);
}

// MARK: UIColor

- (UIColor *)colorWithAlphaComponent:(CGFloat)alpha {
  return [DMDynamicColor colorWithDynamicProvider:^UIColor *(DMTraitCollection *traitCollection) {
    return [self.dynamicProvider(traitCollection) colorWithAlphaComponent:alpha];
  }];
}

// MARK: Methods that do not need forwarding

- (UIColor *)lightColor {
  return [self resolvedColorWithTraitCollection:[DMTraitCollection traitCollectionWithUserInterfaceStyle:DMUserInterfaceStyleLight]];
}

- (UIColor *)darkColor {
  return [self resolvedColorWithTraitCollection:[DMTraitCollection traitCollectionWithUserInterfaceStyle:DMUserInterfaceStyleDark]];
}

- (UIColor *)dm_resolvedColorWithTraitCollection:(DMTraitCollection *)traitCollection {
  return [self resolvedColorWithTraitCollection:traitCollection];;
}

- (UIColor *)dm_namespace:(DMNamespace)namespace resolvedColorWithTraitCollection:(DMTraitCollection *)traitCollection {
  return [self dm_resolvedColorWithTraitCollection:traitCollection];
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
  return [[DMDynamicColorProxy alloc] initWithDynamicProvider:[self.dynamicProvider copy]];
}

@end

// MARK: -

@implementation DMDynamicColor

+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
  return [self colorWithDynamicProvider:^(DMTraitCollection *traitCollection){
    return traitCollection.userInterfaceStyle == DMUserInterfaceStyleDark ? darkColor : lightColor;
  }];
}

+ (UIColor *)colorWithDynamicProvider:(UIColor * _Nonnull (^)(DMTraitCollection * _Nonnull))dynamicProvider {
  return (DMDynamicColor *)[[DMDynamicColorProxy alloc] initWithDynamicProvider:dynamicProvider];
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
