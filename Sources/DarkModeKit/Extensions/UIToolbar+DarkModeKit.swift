//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIToolbar {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    if let dynamicBarTintColor = barTintColor?.copy() as? DynamicColor {
      barTintColor = dynamicBarTintColor
    }
  }
}
