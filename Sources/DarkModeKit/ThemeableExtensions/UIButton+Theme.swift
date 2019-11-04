//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIButton {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    [UIControl.State.normal, .highlighted, .disabled, .selected, .focused].forEach { state in
      if let color = titleColor(for: state)?.copy() as? DynamicColor {
        setTitleColor(color, for: state)
      }
    }
  }
}
