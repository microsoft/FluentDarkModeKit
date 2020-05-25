//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UISlider {
  override func dm_updateDynamicColors() {
    super.dm_updateDynamicColors()

    if let dynamicMinimumTrackTintColor = minimumTrackTintColor?.copy() as? DynamicColor {
      minimumTrackTintColor = dynamicMinimumTrackTintColor
    }
    if let dynamicMaximumTrackTintColor = maximumTrackTintColor?.copy() as? DynamicColor {
      maximumTrackTintColor = dynamicMaximumTrackTintColor
    }
  }
}
