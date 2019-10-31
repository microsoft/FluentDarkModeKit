//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIViewController: Themeable {
  @objc open func themeDidChange() {
    setNeedsStatusBarAppearanceUpdate()
    presentedViewController?.themeDidChange()
    children.forEach { $0.themeDidChange() }
    if isViewLoaded {
      view.themeDidChange()
    }
  }
}
