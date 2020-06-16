//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIProgressView {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }

    dm_updateDynamicColors()

    if let dynamicProgressTintColor = progressTintColor?.copy() as? DynamicColor {
      progressTintColor = dynamicProgressTintColor
    }
    if let dynamicTrackTintColor = trackTintColor?.copy() as? DynamicColor {
      trackTintColor = dynamicTrackTintColor
    }
  }
}
