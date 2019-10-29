//
//  Copyright 2013-2019 Microsoft Inc.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIToolbar {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicBarTintColor = barTintColor?.copy() as? DynamicColor {
      barTintColor = dynamicBarTintColor
    }
  }
}
