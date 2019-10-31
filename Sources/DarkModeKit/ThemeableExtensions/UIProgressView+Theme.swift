//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIProgressView {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicProgressTintColor = progressTintColor?.copy() as? DynamicColor {
      progressTintColor = dynamicProgressTintColor
    }
    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicTrackTintColor = trackTintColor?.copy() as? DynamicColor {
      trackTintColor = dynamicTrackTintColor
    }
  }
}
