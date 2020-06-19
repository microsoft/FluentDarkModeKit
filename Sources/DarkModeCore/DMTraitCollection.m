//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMTraitCollection.h"
#import "UIView+DarkModeKit.h"

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
static void (^_userInterfaceStyleChangeHandler)(DMTraitCollection *, BOOL) = nil;

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
  [self syncImmediatelyAnimated:animated];
}

+ (void)updateUIWithViews:(NSArray<UIView *> *)views viewControllers:(NSArray<UIViewController *> *)viewControllers traitCollection:(DMTraitCollection *)traitCollection animated:(BOOL)animated {
  NSMutableArray<UIView *> *snapshotViews = nil;
  if (animated) {
    // Create snapshot views to ease the transition
    snapshotViews = [NSMutableArray array];
    [views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
      UIView *snapshotView = [view snapshotViewAfterScreenUpdates:NO];
      if (snapshotView) {
        [view addSubview:snapshotView];
        [snapshotViews addObject:snapshotView];
      }
    }];
    [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
      if (!vc.isViewLoaded)
        return;

      UIView *snapshotView = [vc.view snapshotViewAfterScreenUpdates:NO];
      if (snapshotView) {
        [vc.view addSubview:snapshotView];
        [snapshotViews addObject:snapshotView];
      }
    }];
  }

  [views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
    if (@available(iOS 13.0, *)) {
      // Let the system propogate the change
      view.overrideUserInterfaceStyle = traitCollection.uiTraitCollection.userInterfaceStyle;
    }
    else {
      // Propogate the change to subviews
      [view dmTraitCollectionDidChange:nil];
    }
  }];

  [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
    if (@available(iOS 13.0, *)) {
      // Let the system propogate the change
      vc.overrideUserInterfaceStyle = traitCollection.uiTraitCollection.userInterfaceStyle;
    }
    else {
      // Propogate the change to subviews
      [vc dmTraitCollectionDidChange:nil];
    }
  }];

  if (animated) {
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

// MARK: - Observer Registration
+ (void)registerWithApplication:(UIApplication *)application syncImmediately:(BOOL)syncImmediately animated:(BOOL)animated {
  __weak UIApplication *weakApp = application;
  _userInterfaceStyleChangeHandler = ^(DMTraitCollection *traitCollection, BOOL animated) {
    __strong UIApplication *strongApp = weakApp;
    if (!strongApp)
      return;

    [self updateUIWithViews:strongApp.windows viewControllers:nil traitCollection:traitCollection animated:animated];
  };

  if (syncImmediately)
    [self syncImmediatelyAnimated:animated];
}

+ (void)registerWithViewController:(UIViewController *)viewController syncImmediately:(BOOL)syncImmediately animated:(BOOL)animated {
  __weak UIViewController *weakVc = viewController;
  _userInterfaceStyleChangeHandler = ^(DMTraitCollection *traitCollection, BOOL animated) {
    __strong UIViewController *strongVc = weakVc;
    if (!strongVc)
      return;

    [self updateUIWithViews:nil viewControllers:[NSArray arrayWithObject:strongVc] traitCollection:traitCollection animated:animated];
  };

  if (syncImmediately)
    [self syncImmediatelyAnimated:animated];
}

+ (void)syncImmediatelyAnimated:(BOOL)animated {
  if (_userInterfaceStyleChangeHandler)
    _userInterfaceStyleChangeHandler([self overrideTraitCollection], animated);
}

+ (void)unregister {
  _userInterfaceStyleChangeHandler = nil;
}

// MARK: - Swizzling
+ (void)swizzleUIScreenTraitCollectionDidChange {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [UIScreen swizzleTraitCollectionDidChangeToDMTraitCollectionDidChangeWithBlock:^(id<UITraitEnvironment> object, UITraitCollection *previousTraitCollection) {
      if ([DMTraitCollection overrideTraitCollection].userInterfaceStyle != DMUserInterfaceStyleUnspecified) {
        // User has specified explicit dark mode or light mode
        return;
      }

      [self syncImmediatelyAnimated:YES];
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
