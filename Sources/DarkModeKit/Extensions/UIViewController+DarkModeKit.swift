//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIViewController: DMTraitEnvironment {
  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    setNeedsStatusBarAppearanceUpdate()
    presentedViewController?.dmTraitCollectionDidChange(previousTraitCollection)
    children.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
    if isViewLoaded {
      view.dmTraitCollectionDidChange(previousTraitCollection)
    }
  }
}
