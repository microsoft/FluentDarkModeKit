//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
#if SWIFT_PACKAGE
@_exported import DarkModeCore
#endif

public final class DarkModeManager: NSObject {
  public static func setup(with application: UIApplication?) {
    DMTraitCollection.register(application)

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
  }

  // MARK: - Internal

  static func messageForSwizzlingFailed(class cls: AnyClass, selector: Selector) -> String {
    return "Method swizzling for theme failed! Class: \(cls), Selector: \(selector)"
  }
}
