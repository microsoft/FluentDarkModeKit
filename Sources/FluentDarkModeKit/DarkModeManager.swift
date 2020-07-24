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

  public class func register(with configuration: DMEnvironmentConfiguration, for application: UIApplication, syncImmediately: Bool = false, animated: Bool = false) {
    commonSetup(with: configuration)
    DMTraitCollection.register(with: application, syncImmediately: syncImmediately, animated: animated)
  }

  public class func register(with configuration: DMEnvironmentConfiguration, for viewController: UIViewController, syncImmediately: Bool = false, animated: Bool = false) {
    commonSetup(with: configuration)
    DMTraitCollection.register(with: viewController, syncImmediately: syncImmediately, animated: animated)
  }

  public class func unregister() {
    DMTraitCollection.unregister()
  }

  private class func commonSetup(with configuration: DMEnvironmentConfiguration) {
    guard !swizzlingConfigured else {
      return
    }

    defer { swizzlingConfigured = true }

    DMTraitCollection.setupEnvironment(with: configuration)
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
