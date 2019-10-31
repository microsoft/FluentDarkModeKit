//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UINavigationBar {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicBarTintColor = barTintColor?.copy() as? DynamicColor {
      barTintColor = dynamicBarTintColor
    }
  }
}
