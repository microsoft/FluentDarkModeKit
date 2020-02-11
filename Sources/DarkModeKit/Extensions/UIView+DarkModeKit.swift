//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIView {
  static let swizzleWillMoveToWindowOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(willMove(toWindow:)), to: #selector(dm_willMove(toWindow:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(willMove(toWindow:))))
    }
  }()

  @objc private dynamic func dm_willMove(toWindow window: UIWindow?) {
    dm_willMove(toWindow: window)
    if window != nil {
      dm_updateDynamicColors()
      dm_updateDynamicImages()
    }
  }
}

extension UIView {
  static let swizzleSetTintColorOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: tintColor), to: #selector(dm_setTintColor)) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(setter: tintColor)))
    }
  }()

  @objc private dynamic func dm_setTintColor(_ color: UIColor) {
    dm_dynamicTintColor = color as? DynamicColor
    dm_setTintColor(color)
  }
}
