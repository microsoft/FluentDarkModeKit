//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
#if SWIFT_PACKAGE
@_exported import DarkModeCore
#endif

public final class DarkModeManager: DMDarkModeManager {
  public static func setup() {
    if #available(iOS 13, *), interoperableWithUIKit {
      return
    }

    // Colors
    UIView.swizzleWillMoveToWindowOnce
    UIView.dm_swizzleSetBackgroundColor()
    UIView.swizzleSetTintColorOnce
    UITextField.swizzleTextFieldWillMoveToWindowOnce
    UILabel.swizzleDidMoveToWindowOnce

    // Images
    UIImage.dm_swizzleIsEqual()
    UIImageView.swizzleSetImageOnce
    UIImageView.swizzleInitImageOnce
    UITabBarItem.swizzleSetImageOnce
    UITabBarItem.swizzleSetSelectedImageOnce
  }

  /// Update application's appearance based on current theme (This method is for main app.)
  ///
  /// - Parameters:
  ///   - application: The application needs to update.
  ///   - animated: Use animation or not.
  @objc public static func updateAppearance(for application: UIApplication, animated: Bool) {
    application.updateAppearance(with: application.windows, animated: animated)

    if #available(iOS 13, *) {
      for window in application.windows {
        window.overrideUserInterfaceStyle = DMTraitCollection.current.userInterfaceStyle.uiUserInterfaceStyle
      }
    }
  }

  // MARK: - Internal

  static func messageForSwizzlingFailed(class cls: AnyClass, selector: Selector) -> String {
    return "Method swizzling for theme failed! Class: \(cls), Selector: \(selector)"
  }
}

// MARK: -

extension DMUserInterfaceStyle {

  @available(iOS 13, *)
  var uiUserInterfaceStyle: UIUserInterfaceStyle {
    switch self {
    case .unspecified: return .unspecified
    case .dark: return .dark
    case .light: return .light
    @unknown default: return .unspecified
    }
  }

}

// MARK: -

extension DMTraitEnvironment {
  /// Trigger `themeDidChange()`.
  ///
  /// - Parameters:
  ///   - views: Views visiable by user, will be snapshoted if use animation.
  ///   - animated: Use animation or not.
  fileprivate func updateAppearance(with views: [UIView], animated: Bool) {
    assert(Thread.isMainThread)

    if animated {
      var snapshotViews: [UIView] = []
      views.forEach { view in
        guard let snapshotView = view.snapshotView(afterScreenUpdates: false) else {
          return
        }
        view.addSubview(snapshotView)
        snapshotViews.append(snapshotView)
      }

      dmTraitCollectionDidChange(nil)

      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: [], animations: {
        snapshotViews.forEach { $0.alpha = 0 }
      }) { _ in
        snapshotViews.forEach { $0.removeFromSuperview() }
      }
    }
    else {
      dmTraitCollectionDidChange(nil)
    }
  }
}
