//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIViewController: DMTraitEnvironment {
  public var dmTraitCollection: DMTraitCollection {
    if #available(iOS 13.0, *) {
      return DMTraitCollection(uiTraitCollection: traitCollection)
    }
    return DMTraitCollection.override
  }

  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    if #available(iOS 13.0, *) {
      return
    }

    setNeedsStatusBarAppearanceUpdate()
    presentedViewController?.dmTraitCollectionDidChange(previousTraitCollection)
    children.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
    if isViewLoaded {
      view.dmTraitCollectionDidChange(previousTraitCollection)
    }
  }
}
