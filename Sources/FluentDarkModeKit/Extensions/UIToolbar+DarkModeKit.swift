//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIToolbar {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }
    else {
      dm_updateDynamicColors()

      if let dynamicBarTintColor = barTintColor?.copy() as? DynamicColor {
        barTintColor = dynamicBarTintColor
      }
    }
  }
}
