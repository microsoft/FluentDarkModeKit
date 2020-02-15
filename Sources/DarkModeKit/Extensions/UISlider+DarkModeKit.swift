//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UISlider {
  override func dm_updateDynamicColors() {
    super.dm_updateDynamicColors()

    if let dynamicMinimumTrackTintColor = minimumTrackTintColor?.copy() as? DynamicColor {
      minimumTrackTintColor = dynamicMinimumTrackTintColor
    }
    if let dynamicMaximumTrackTintColor = maximumTrackTintColor?.copy() as? DynamicColor {
      maximumTrackTintColor = dynamicMaximumTrackTintColor
    }
    if let thumbTintColor = thumbTintColor?.copy() as? DynamicColor {
      self.thumbTintColor = thumbTintColor
    }
  }
}
