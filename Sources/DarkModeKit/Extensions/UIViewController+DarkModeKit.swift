//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIViewController: DMTraitEnvironment {
  open func dm_traitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    setNeedsStatusBarAppearanceUpdate()
    presentedViewController?.dm_traitCollectionDidChange(previousTraitCollection)
    children.forEach { $0.dm_traitCollectionDidChange(previousTraitCollection) }
    if isViewLoaded {
      view.dm_traitCollectionDidChange(previousTraitCollection)
    }
  }
}
