//
//  Copyright 2013-2019 Microsoft Inc.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIButton {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    [UIControl.State.normal, .highlighted, .disabled, .selected, .focused].forEach { state in
      // swiftlint:disable:next prefer_type_safe_clone
      if let color = titleColor(for: state)?.copy() as? DynamicColor {
        setTitleColor(color, for: state)
      }
    }
  }
}
