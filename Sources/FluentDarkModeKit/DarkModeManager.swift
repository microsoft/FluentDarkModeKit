//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
#if SWIFT_PACKAGE
@_exported import DarkModeCore
#endif

public final class DarkModeManager: NSObject {
  private static var swizzlingConfigured = false

  public class func register(with application: UIApplication, useUIImageAsset: Bool, syncImmediately: Bool = false, animated: Bool = false) {
    commonSetup(useUIImageAsset)
    DMTraitCollection.register(with: application, syncImmediately: syncImmediately, animated: animated)
  }

  public class func register(with viewController: UIViewController, useUIImageAsset: Bool, syncImmediately: Bool = false, animated: Bool = false) {
    commonSetup(useUIImageAsset)
    DMTraitCollection.register(with: viewController, syncImmediately: syncImmediately, animated: animated)
  }

  public class func unregister() {
    DMTraitCollection.unregister()
  }

  private class func commonSetup(_ useUIImageAsset: Bool) {
    guard !swizzlingConfigured else {
      return
    }

    defer { swizzlingConfigured = true }

    DMTraitCollection.setupEnvironment(useUIImageAsset)
    guard #available(iOS 13.0, *) else {
      // Colors
      UIView.swizzleWillMoveToWindowOnce
      UITextField.swizzleTextFieldWillMoveToWindowOnce
      UILabel.swizzleDidMoveToWindowOnce

      // Images
      UIImageView.swizzleSetImageOnce
      UIImageView.swizzleInitImageOnce
      UITabBarItem.swizzleSetImageOnce
      UITabBarItem.swizzleSetSelectedImageOnce
      return
    }
  }

  // MARK: - Internal

  static func messageForSwizzlingFailed(class cls: AnyClass, selector: Selector) -> String {
    return "Method swizzling for theme failed! Class: \(cls), Selector: \(selector)"
  }
}
