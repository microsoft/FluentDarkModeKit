//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMTraitCollection.h"
#import "UIApplication+DarkModeKit.h"

@import ObjectiveC;

@implementation DMTraitCollection

static DMTraitCollection *_lastManuallySetTraitCollection = nil; // This is set manually in setCurrentTraitCollection:animated
static __weak UIApplication *_registeredApplication = nil;

+ (DMTraitCollection *)currentTraitCollection {
  DMTraitCollection *lastTraitCollection = [self lastManuallySetTraitCollection];
  if (@available(iOS 13.0, *)) {
    if (lastTraitCollection.userInterfaceStyle == DMUserInterfaceStyleUnspecified) {
      // Return the ones used from the system when no specific user interface style is explicitly set
      return [self currentSystemTraitCollection];
    }
  }
  return lastTraitCollection;
}

+ (DMTraitCollection *)lastManuallySetTraitCollection {
  if (!_lastManuallySetTraitCollection) {
    // Provide unspecified at first
    _lastManuallySetTraitCollection = [DMTraitCollection traitCollectionWithUserInterfaceStyle:DMUserInterfaceStyleUnspecified];
  }
  return _lastManuallySetTraitCollection;
}

+ (DMTraitCollection *)currentSystemTraitCollection API_AVAILABLE(ios(13.0)) {
  return [DMTraitCollection traitCollectionWithUITraitCollection:UIScreen.mainScreen.traitCollection];
}

+ (void)setCurrentTraitCollection:(DMTraitCollection *)currentTraitCollection animated:(BOOL)animated {
  _lastManuallySetTraitCollection = currentTraitCollection;
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
  dispatch_once(&onceToken, ^{
    SEL selector = @selector(traitCollectionDidChange:);
    Method method = class_getInstanceMethod(UIScreen.class, selector);
    if (!method)
      NSAssert(NO, @"Method not found for [UIScreen traitCollectionDidChange:]");

    IMP imp = method_getImplementation(method);
    class_replaceMethod(UIScreen.class, selector, imp_implementationWithBlock(^(UIScreen *self, UITraitCollection *previousTraitCollection) {
      ((void (*)(UIScreen *, SEL, UITraitCollection *))imp)(self, selector, previousTraitCollection);
      if ([DMTraitCollection lastManuallySetTraitCollection].userInterfaceStyle != DMUserInterfaceStyleUnspecified) {
        // User has specified explicit dark mode or light mode
        return;
      }
      [DMTraitCollection updateUIWithTraitCollection:[DMTraitCollection traitCollectionWithUserInterfaceStyle:DMUserInterfaceStyleUnspecified] animated:YES];
    }), method_getTypeEncoding(method));
  });
}

@end
