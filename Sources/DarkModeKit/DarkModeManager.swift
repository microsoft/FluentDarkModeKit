//
//  Copyright 2013-2019 Microsoft Inc.
//

/// The protocol for theme changing.
///
/// This protocol is very similar to `UITraitEnvironment` protocol.
///
/// Adoped by `UIApplication`, `UIView` (`UIWindow`), and `UIViewController`.
///
/// # How Theme Changing Works
///
/// After the current theme changed, you can call `Theme.updateAppearance(for:animated:)` to update UI.
/// `Theme.updateAppearance(for:animated:)` will call `themeDidChange()` for passed in instance.
///
/// These classes will propagate `themeDidChange()`:
/// - `UIApplication`: It will propagate `themeDidChange()` to `UIWindow` through `windows`.
/// - `UIWindow`: It will propagate `themeDidChange()` to `UIViewController` through `rootViewController`.
/// - `UIViewController`: It will propagate `themeDidChange()` to `UIViewController` through `presentedViewController`
///   and `children`, propagate `themeDidChange()` to `UIView` through `view`.
/// - `UIView`: It will propagate `themeDidChange()` to `UIView` through `subviews`.
///
/// For the basic, `UIView.themeDidChange()` will call `setNeedsUpdate()` to trigger layouts, this gives you a chance
/// to update some non-automatic changing colors like `CALayer`'s color in `UIView.layoutSubviews()`
/// or `UIViewController.viewDidLayoutSubviews().
///
/// For automatic color changing part, you can see each classes' `themeDidChange()` for details.
public protocol Themeable {
  func themeDidChange()
}

public final class DarkModeManager: NSObject {
  public static func setup(updateAppearance: @escaping (UIApplication) -> Void) {
    UIApplication.updateAppearance = updateAppearance

    // Colors
    UIView.swizzleWillMoveToWindowOnce
    UIView.swizzleSetBackgroundColorOnce
    UIView.swizzleSetTintColorOnce
    UITextField.swizzleTextFieldWillMoveToWindowOnce
    UILabel.swizzleDidMoveToWindowOnce

    // Images
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
  }

  // MARK: - Internal

  static func messageForSwizzlingFailed(class cls: AnyClass, selector: Selector) -> String {
    return "Method swizzling for theme failed! Class: \(cls), Selector: \(selector)"
  }
}

// MARK: -

extension Themeable {
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

      themeDidChange()

      UIView.animate(withDuration: 0.25, animations: {
        snapshotViews.forEach { $0.alpha = 0 }
      }, completion: { _ in
        snapshotViews.forEach { $0.removeFromSuperview() }
      })
    }
    else {
      themeDidChange()
    }
  }
}
