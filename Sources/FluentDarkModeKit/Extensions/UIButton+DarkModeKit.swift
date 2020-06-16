//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIButton {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }

    dm_updateDynamicColors()

    [UIControl.State.normal, .highlighted, .disabled, .selected, .focused].forEach { state in
      if let color = titleColor(for: state)?.copy() as? DynamicColor {
        setTitleColor(color, for: state)
      }
    }
  }
}
