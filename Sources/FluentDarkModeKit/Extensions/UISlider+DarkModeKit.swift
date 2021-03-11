//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UISlider {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }
    else {
      dm_updateDynamicColors()

      if let dynamicMinimumTrackTintColor = minimumTrackTintColor?.copy() as? DynamicColor {
        minimumTrackTintColor = dynamicMinimumTrackTintColor
      }
      if let dynamicMaximumTrackTintColor = maximumTrackTintColor?.copy() as? DynamicColor {
        maximumTrackTintColor = dynamicMaximumTrackTintColor
      }
    }
  }
}
