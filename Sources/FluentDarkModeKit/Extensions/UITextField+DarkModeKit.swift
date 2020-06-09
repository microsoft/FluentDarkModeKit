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
    let selector = #selector(willMove(toWindow:))
    guard let method = class_getInstanceMethod(UITextField.self, selector) else {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UITextField.self, selector: selector))
      return
    }

    let imp = method_getImplementation(method)
    class_replaceMethod(UITextField.self, selector, imp_implementationWithBlock({ (self: UITextField, window: UIWindow?) -> Void in
      let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UITextField, Selector, UIWindow?) -> Void).self)
      oldIMP(self, selector, window)
      if window != nil {
        self.dm_updateDynamicColors()
        self.dm_updateDynamicImages()
      }
    } as @convention(block) (UITextField, UIWindow?) -> Void), method_getTypeEncoding(method))
  }()
}
