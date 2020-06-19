//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMTraitCollection.h"
#import "UIApplication+DarkModeKit.h"

@import ObjectiveC;

@implementation NSObject (DMTraitEnvironment)

+ (void)swizzleTraitCollectionDidChangeToDMTraitCollectionDidChange {
  [self swizzleTraitCollectionDidChangeToDMTraitCollectionDidChangeWithBlock:nil];
}

+ (void)swizzleTraitCollectionDidChangeToDMTraitCollectionDidChangeWithBlock:(void (^)(id<UITraitEnvironment>, UITraitCollection *))block API_AVAILABLE(ios(13.0)) {
  // Only swizzling classes that conforms to both UITraitEnvironment & DMTraitEnvironment
  if (!class_conformsToProtocol(self, @protocol(UITraitEnvironment)) || !class_conformsToProtocol(self, @protocol(DMTraitEnvironment))) {
    return;
  }

  SEL selector = @selector(traitCollectionDidChange:);
  Method method = class_getInstanceMethod(self, selector);

  if (!method)
    NSAssert(NO, @"Method not found for [%@ traitCollectionDidChange:]", NSStringFromClass(self));

  IMP imp = method_getImplementation(method);
  class_replaceMethod(self, selector, imp_implementationWithBlock(^(id<UITraitEnvironment> self, UITraitCollection *previousTraitCollection) {
    // Call previous implementation
    ((void (*)(NSObject *, SEL, UITraitCollection *))imp)(self, selector, previousTraitCollection);

    if (previousTraitCollection != nil && previousTraitCollection.userInterfaceStyle == self.traitCollection.userInterfaceStyle) {
      // We only care about userInterfaceStyle change currently, so filter out
      // calling without this specific change
      return;
    }

    // Call DMTraitEnvironment
    [(id <DMTraitEnvironment>)self dmTraitCollectionDidChange:previousTraitCollection == nil ? nil : [DMTraitCollection traitCollectionWithUITraitCollection:previousTraitCollection]];

    // Call custom block
    if (block) {
      block(self, previousTraitCollection);
    }
  }), method_getTypeEncoding(method));
}

@end

@implementation DMTraitCollection

static DMTraitCollection *_overrideTraitCollection = nil; // This is set manually in setCurrentTraitCollection:animated
static __weak UIApplication *_registeredApplication = nil;

+ (DMTraitCollection *)currentTraitCollection {
  if (@available(iOS 13.0, *)) {
    return [DMTraitCollection traitCollectionWithUITraitCollection:UITraitCollection.currentTraitCollection];
  }
  return [self overrideTraitCollection];
}

+ (DMTraitCollection *)overrideTraitCollection {
  if (!_overrideTraitCollection) {
    // Provide unspecified at first
    _overrideTraitCollection = [DMTraitCollection traitCollectionWithUserInterfaceStyle:DMUserInterfaceStyleUnspecified];
  }
  return _overrideTraitCollection;
}

+ (DMTraitCollection *)currentSystemTraitCollection API_AVAILABLE(ios(13.0)) {
  return [DMTraitCollection traitCollectionWithUITraitCollection:UIScreen.mainScreen.traitCollection];
}

+ (void)setOverrideTraitCollection:(DMTraitCollection *)currentTraitCollection animated:(BOOL)animated {
  _overrideTraitCollection = currentTraitCollection;
  [self updateUIWithTraitCollection:currentTraitCollection animated:animated];
}

+ (void)updateUIWithTraitCollection:(DMTraitCollection *)traitCollection animated:(BOOL)animated {
  // Update all windows' overrideUserInterfaceStyle to achieve a global theme
  UIApplication *application = _registeredApplication;
  if (!application) {
    return;
  }

  if (animated) {
    // Create snapshot views to ease the transition
    NSArray<UIWindow *> *windows = application.windows;
    NSMutableArray<UIView *> *snapshotViews = [NSMutableArray array];
    [windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
      UIView *snapshotView = [window snapshotViewAfterScreenUpdates:NO];
      if (snapshotView) {
        [window addSubview:snapshotView];
        [snapshotViews addObject:snapshotView];
      }
    }];

    if (@available(iOS 13.0, *)) {
      // Update user interface style with overrideUserInterfaceStyle
      [windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        window.overrideUserInterfaceStyle = traitCollection.uiTraitCollection.userInterfaceStyle;
      }];
    } else {
      [application dmTraitCollectionDidChange:nil];
    }

    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.25 delay:0 options:0 animations:^{
      [snapshotViews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.alpha = 0;
      }];
    } completion:^(UIViewAnimatingPosition finalPosition) {
      [snapshotViews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
      }];
    }];
  }
  else {
    if (@available(iOS 13.0, *)) {
      // Update user interface style with overrideUserInterfaceStyle
      [[application windows] enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        window.overrideUserInterfaceStyle = traitCollection.uiTraitCollection.userInterfaceStyle;
      }];
    }
    else {
      [application dmTraitCollectionDidChange:nil];
    }
  }
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

+ (void)registerApplication:(UIApplication *)application {
  _registeredApplication = application;
}

+ (void)swizzleUIScreenTraitCollectionDidChange {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{\
    [UIScreen swizzleTraitCollectionDidChangeToDMTraitCollectionDidChangeWithBlock:^(id<UITraitEnvironment> self, UITraitCollection *previousTraitCollection) {
      if ([DMTraitCollection overrideTraitCollection].userInterfaceStyle != DMUserInterfaceStyleUnspecified) {
        // User has specified explicit dark mode or light mode
        return;
      }
      [DMTraitCollection updateUIWithTraitCollection:[DMTraitCollection traitCollectionWithUserInterfaceStyle:DMUserInterfaceStyleUnspecified] animated:YES];
    }];
  });
}

@end

@interface UIScreen (DMTraitEnvironment) <DMTraitEnvironment>

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection;

@end

@implementation UIScreen (DMTraitEnvironment)

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {}

@end
