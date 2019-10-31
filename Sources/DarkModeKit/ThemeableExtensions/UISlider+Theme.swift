//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UISlider {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicMinimumTrackTintColor = minimumTrackTintColor?.copy() as? DynamicColor {
      minimumTrackTintColor = dynamicMinimumTrackTintColor
    }
    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicMaximumTrackTintColor = maximumTrackTintColor?.copy() as? DynamicColor {
      maximumTrackTintColor = dynamicMaximumTrackTintColor
    }
  }
}
