//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UITextField {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    // swiftlint:disable:next prefer_type_safe_clone
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
    if !dm_swizzleInstanceMethod(#selector(willMove(toWindow:)), to: #selector(outlookTextFieldWillMove(toWindow:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UITextField.self, selector: #selector(willMove(toWindow:))))
    }
  }()

  @objc private dynamic func outlookTextFieldWillMove(toWindow window: UIWindow?) {
    outlookTextFieldWillMove(toWindow: window)
    if window != nil {
      _updateDynamicColors()
      _updateDynamicImages()
    }
  }
}
