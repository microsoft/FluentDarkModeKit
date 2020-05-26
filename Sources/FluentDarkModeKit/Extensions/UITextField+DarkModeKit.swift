//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UITextField {
  override func dm_updateDynamicColors() {
    super.dm_updateDynamicColors()

    if let dynamicTextColor = textColor?.copy() as? DynamicColor {
      textColor = dynamicTextColor
    }

    keyboardAppearance = {
      if DMTraitCollection.current.userInterfaceStyle == .dark {
        return .dark
      }
      else {
        return .default
      }
    }()
  }
}

extension UITextField {

  /// `UITextField` will not call `super.willMove(toWindow:)` in its implementation, so we need to swizzle it separately.
  static let swizzleTextFieldWillMoveToWindowOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(willMove(toWindow:)), to: #selector(dm_textFieldWillMove(toWindow:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UITextField.self, selector: #selector(willMove(toWindow:))))
    }
  }()

  @objc private dynamic func dm_textFieldWillMove(toWindow window: UIWindow?) {
    dm_textFieldWillMove(toWindow: window)
    if window != nil {
      dm_updateDynamicColors()
      dm_updateDynamicImages()
    }
  }
}
