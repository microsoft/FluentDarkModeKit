//
//  Copyright 2013-2019 Microsoft Inc.
//

#import "OLMDynamicImage.h"
#import "DMTraitCollection.h"
#import <DarkModeKit/DarkModeKit-Swift.h>

// MARK: - OLMDynamicImageProxy

@interface OLMDynamicImageProxy ()
@property (nonatomic, strong) UIImage *lightImage;
@property (nonatomic, strong) UIImage *darkImage;
@property (nonatomic, readonly) UIImage *resolvedImage;
@end

@implementation OLMDynamicImageProxy

- (instancetype)initWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage
{
  self.lightImage = lightImage;
  self.darkImage = darkImage;
  // For now, we don't support `nil` images as it will cause bad result
  // when using in swift:
  // `someOptionalDynamicImage as? UIImage` will return `true`
  // even when the internal `lightImage` or `darkImage` is nil
  NSAssert(self.darkImage != nil, @"Nil image is not supported yet");
  if (self.lightImage == nil)
  {
    NSAssert(NO, @"Nil light image is not supported yet");
    self.lightImage = [UIImage new];
  }
  if (self.darkImage == nil)
  {
    NSAssert(NO, @"Nil dark image is not supported yet");
    self.darkImage = [UIImage new];
  }
  return self;
}

- (UIImage *)resolvedImage
{
  if (DMTraitCollection.currentTraitCollection.userInterfaceStyle == DMUserInterfaceStyleDark)
  {
    return self.darkImage;
  }
  else {
    return self.lightImage;
  }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [self.resolvedImage methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  [invocation invokeWithTarget:self.resolvedImage];
}

#pragma mark - Public Methods

/// Passing these public methods to both light and dark images
/// instead of only to the `resolvedImage`

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets
{
  return (UIImage *)[[OLMDynamicImageProxy alloc] initWithLightImage:[self.lightImage resizableImageWithCapInsets:capInsets] darkImage:[self.darkImage resizableImageWithCapInsets:capInsets]];
}

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
{
  return (UIImage *)[[OLMDynamicImageProxy alloc] initWithLightImage:[self.lightImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode] darkImage:[self.darkImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode]];
}

- (UIImage *)imageWithAlignmentRectInsets:(UIEdgeInsets)alignmentInsets
{
  return (UIImage *)[[OLMDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithAlignmentRectInsets:alignmentInsets] darkImage:[self.darkImage imageWithAlignmentRectInsets:alignmentInsets]];
}

- (UIImage *)imageWithRenderingMode:(UIImageRenderingMode)renderingMode
{
  return (UIImage *)[[OLMDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithRenderingMode:renderingMode] darkImage:[self.darkImage imageWithRenderingMode:renderingMode]];
}

- (UIImage *)imageFlippedForRightToLeftLayoutDirection
{
  return (UIImage *)[[OLMDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageFlippedForRightToLeftLayoutDirection] darkImage:[self.darkImage imageFlippedForRightToLeftLayoutDirection]];
}

- (UIImage *)imageWithHorizontallyFlippedOrientation
{
  return (UIImage *)[[OLMDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithHorizontallyFlippedOrientation] darkImage:[self.darkImage imageWithHorizontallyFlippedOrientation]];
}

- (id)copy
{
  return [self copyWithZone:nil];
}

- (id)copyWithZone:(NSZone *)zone
{
  return [[OLMDynamicImageProxy alloc] initWithLightImage:self.lightImage darkImage:self.darkImage];
}

@end

// MARK: - UIImage

@implementation UIImage (DynamicImage)

+ (void)load
{
  [UIImage dm_swizzleInstanceMethod:@selector(isEqual:) to:@selector(outlookIsEqual:)];
}

- (instancetype)initWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage
{
  return (UIImage *)[[OLMDynamicImageProxy alloc] initWithLightImage:lightImage darkImage:darkImage];
}

- (BOOL)outlookIsEqual:(UIImage *)other
{
  /// On iOS 13, UIImage `isEqual:` somehow changes internally and doesn't work for `NSProxy`,
  /// here we forward the message to internal images manually
  UIImage *realSelf = self;
  UIImage *realOther = other;
  if (object_getClass(self) == OLMDynamicImageProxy.class)
  {
    realSelf = ((OLMDynamicImageProxy *)self).resolvedImage;
  }
  if (object_getClass(other) == OLMDynamicImageProxy.class)
  {
    realOther = ((OLMDynamicImageProxy *)other).resolvedImage;
  }
  return [realSelf outlookIsEqual:realOther];
}

@end
