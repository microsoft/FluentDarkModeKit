//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

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
