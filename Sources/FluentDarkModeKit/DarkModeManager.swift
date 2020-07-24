//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
#if SWIFT_PACKAGE
@_exported import DarkModeCore
@_implementationOnly import DarkModeCorePrivate
#else
@_implementationOnly import FluentDarkModeKit.Private
#endif

public final class DarkModeManager: NSObject {
  private static var swizzlingConfigured = false

  public static func setup(with configuration: DMEnvironmentConfiguration) {
    commonSetup(with: configuration)
  }

  public static func register(with application: UIApplication, syncImmediately: Bool = false, animated: Bool = false) {
    DMTraitCollection.register(with: application, syncImmediately: syncImmediately, animated: animated)
  }

  @available(iOSApplicationExtension 11.0, *)
  public static func register(with viewController: UIViewController, syncImmediately: Bool = false, animated: Bool = false) {
    DMTraitCollection.register(with: viewController, syncImmediately: syncImmediately, animated: animated)
  }

  public static func unregister() {
    DMTraitCollection.unregister()
  }

  private static func commonSetup(with configuration: DMEnvironmentConfiguration) {
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
