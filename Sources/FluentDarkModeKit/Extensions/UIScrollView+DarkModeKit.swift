//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIScrollView {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }

    dm_updateDynamicColors()

    indicatorStyle = {
      if DMTraitCollection.override.userInterfaceStyle == .dark {
        return .white
      }
      else {
        return .default
      }
    }()
  }
}
