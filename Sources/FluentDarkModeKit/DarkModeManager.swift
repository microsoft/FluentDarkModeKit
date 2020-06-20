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

  public class func register(with application: UIApplication, syncImmediately: Bool = false, animated: Bool = false) {
    commonSetup()
    DMTraitCollection.register(with: application, syncImmediately: syncImmediately, animated: animated)
  }

  public class func register(with viewController: UIViewController, syncImmediately: Bool = false, animated: Bool = false) {
    commonSetup()
    DMTraitCollection.register(with: viewController, syncImmediately: syncImmediately, animated: animated)
  }

  public class func unregister() {
    DMTraitCollection.unregister()
  }

  private class func commonSetup() {
    guard !swizzlingConfigured else {
      return
    }

    if #available(iOS 13.0, *) {
      DMTraitCollection.swizzleUIScreenTraitCollectionDidChange()
      UIView.swizzleTraitCollectionDidChangeToDMTraitCollectionDidChange()
      UIViewController.swizzleTraitCollectionDidChangeToDMTraitCollectionDidChange()
    }
    else {
      // Colors
      UIView.swizzleWillMoveToWindowOnce
      UIView.dm_swizzleSetBackgroundColor()
      UIView.dm_swizzleSetTintColor()
      UITextField.swizzleTextFieldWillMoveToWindowOnce
      UILabel.swizzleDidMoveToWindowOnce

      // Images
      UIImage.dm_swizzleIsEqual()
      UIImageView.swizzleSetImageOnce
      UIImageView.swizzleInitImageOnce
      UITabBarItem.swizzleSetImageOnce
      UITabBarItem.swizzleSetSelectedImageOnce
    }

    swizzlingConfigured = true
  }

  // MARK: - Internal

  static func messageForSwizzlingFailed(class cls: AnyClass, selector: Selector) -> String {
    return "Method swizzling for theme failed! Class: \(cls), Selector: \(selector)"
  }
}
