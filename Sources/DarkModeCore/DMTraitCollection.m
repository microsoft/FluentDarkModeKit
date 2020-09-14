//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMEnvironmentConfiguration.h"
#import "DMTraitCollection.h"
#import "UIViewController+DarkModeKit.h"
#import "UIView+DarkModeKit.h"
#import "UIView+DarkModeKitSwizzling.h"
#import "UIImage+DarkModeKitSwizzling.h"

@import ObjectiveC;

@interface NSObject (DMTraitEnvironment)

+ (void)swizzleTraitCollectionDidChangeToDMTraitCollectionDidChange API_AVAILABLE(ios(13.0));

@end

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

    // Call DMTraitEnvironment method
    [(id <DMTraitEnvironment>)self dmTraitCollectionDidChange:previousTraitCollection == nil ? nil : [DMTraitCollection traitCollectionWithUITraitCollection:previousTraitCollection]];

    // Call custom block
    if (block) {
      block(self, previousTraitCollection);
    }
  }), method_getTypeEncoding(method));
}

@end

@implementation DMTraitCollection

static DMTraitCollection *_overrideTraitCollection = nil; // This is set manually in setOverrideTraitCollection:animated
static void (^_userInterfaceStyleChangeHandler)(DMTraitCollection *, BOOL) = nil;
static void (^_themeChangeHandler)(void) = nil;
static void (^_windowThemeChangeHandler)(UIWindow *) = nil;
static BOOL _isObservingNewWindowAddNotification = NO;

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

+ (void)setOverrideTraitCollection:(DMTraitCollection *)overrideTraitCollection animated:(BOOL)animated {
  _overrideTraitCollection = overrideTraitCollection;
  [self syncImmediatelyAnimated:animated];
}

+ (void)updateUIWithViews:(NSArray<UIView *> *)views viewControllers:(NSArray<UIViewController *> *)viewControllers traitCollection:(DMTraitCollection *)traitCollection animated:(BOOL)animated {
  NSMutableArray<UIView *> *snapshotViews = nil;
  if (animated) {
    // Create snapshot views to ease the transition
    snapshotViews = [NSMutableArray array];
    [views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
      if (view.isHidden) // Skip hidden views
        return;

      UIView *snapshotView = [view snapshotViewAfterScreenUpdates:NO];
      if (snapshotView) {
        [view addSubview:snapshotView];
        [snapshotViews addObject:snapshotView];
      }
    }];
    [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
      if (!vc.isViewLoaded || vc.view.isHidden) // Skip view controllers that are not loaded and hidden views
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
  __weak typeof(self) weakSelf = self;
  _userInterfaceStyleChangeHandler = ^(DMTraitCollection *traitCollection, BOOL animated) {
    __strong UIApplication *strongApp = weakApp;
    if (!strongApp)
      return;

    [weakSelf updateUIWithViews:strongApp.windows viewControllers:nil traitCollection:traitCollection animated:animated];

    if (_themeChangeHandler)
      _themeChangeHandler();
  };

  [self observeNewWindowNotificationIfNeeded];

  if (syncImmediately)
    [self syncImmediatelyAnimated:animated];
}

+ (void)registerWithViewController:(UIViewController *)viewController syncImmediately:(BOOL)syncImmediately animated:(BOOL)animated {
  __weak UIViewController *weakVc = viewController;
  __weak typeof(self) weakSelf = self;
  _userInterfaceStyleChangeHandler = ^(DMTraitCollection *traitCollection, BOOL animated) {
    __strong UIViewController *strongVc = weakVc;
    if (!strongVc)
      return;

    [weakSelf updateUIWithViews:nil viewControllers:[NSArray arrayWithObject:strongVc] traitCollection:traitCollection animated:animated];

    if (_themeChangeHandler)
      _themeChangeHandler();
  };

  if (syncImmediately)
    [self syncImmediatelyAnimated:animated];
}

+ (void)observeNewWindowNotificationIfNeeded {
  if (_isObservingNewWindowAddNotification)
    return;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];
}

+ (void)windowDidBecomeVisible:(NSNotification *)notification {
  NSObject *object = [notification object];
  if ([object isKindOfClass:[UIWindow class]])
    [self updateUIWithViews:@[(UIWindow *)object] viewControllers:nil traitCollection:[self overrideTraitCollection] animated:NO];
}

+ (void)syncImmediatelyAnimated:(BOOL)animated {
  if (_userInterfaceStyleChangeHandler)
    _userInterfaceStyleChangeHandler([self overrideTraitCollection], animated);
}

+ (void)unregister {
  _userInterfaceStyleChangeHandler = nil;
  if (_isObservingNewWindowAddNotification) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    _isObservingNewWindowAddNotification = NO;
  }
}

// MARK: - Swizzling
+ (void)swizzleUIScreenTraitCollectionDidChange API_AVAILABLE(ios(13.0)) {
  static dispatch_once_t onceToken;
  __weak typeof(self) weakSelf = self;
  dispatch_once(&onceToken, ^{
    [UIScreen swizzleTraitCollectionDidChangeToDMTraitCollectionDidChangeWithBlock:^(id<UITraitEnvironment> object, UITraitCollection *previousTraitCollection) {
      if ([DMTraitCollection overrideTraitCollection].userInterfaceStyle != DMUserInterfaceStyleUnspecified) {
        // User has specified explicit dark mode or light mode
        return;
      }

      [weakSelf syncImmediatelyAnimated:YES];
    }];
  });
}

+ (void)setupEnvironmentWithConfiguration:(DMEnvironmentConfiguration *)configuration {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (@available(iOS 13.0, *)) {
      [DMTraitCollection swizzleUIScreenTraitCollectionDidChange];
      [UIView swizzleTraitCollectionDidChangeToDMTraitCollectionDidChange];
      [UIViewController swizzleTraitCollectionDidChangeToDMTraitCollectionDidChange];
      if (!configuration.useImageAsset)
        [UIImage dm_swizzleIsEqual];

      _windowThemeChangeHandler = configuration.windowThemeChangeHandler;
    }
    else {
      [UIView dm_swizzleSetTintColor];
      [UIView dm_swizzleSetBackgroundColor];
      [UIImage dm_swizzleIsEqual];
    }

    _themeChangeHandler = configuration.themeChangeHandler;
  });
}

@end

@interface UIScreen (DMTraitEnvironment) <DMTraitEnvironment>

@end

@implementation UIScreen (DMTraitEnvironment)

- (DMTraitCollection *)dmTraitCollection {
  if (@available(iOS 13.0, *)) {
    return [DMTraitCollection traitCollectionWithUITraitCollection:self.traitCollection];
  }
  return DMTraitCollection.overrideTraitCollection;
}

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {}

@end

@interface UIWindow (DMTraitEnvironment)

@end

@implementation UIWindow (DMTraitEnvironment)

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
  [super dmTraitCollectionDidChange:previousTraitCollection];

  if (@available(iOS 13, *)) {
    if (previousTraitCollection.userInterfaceStyle != self.dmTraitCollection.userInterfaceStyle && _windowThemeChangeHandler)
      _windowThemeChangeHandler(self);
  } else {
    [[self rootViewController] dmTraitCollectionDidChange:previousTraitCollection];
  }
}

@end
