//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIView: Themeable {
  @objc open func themeDidChange() {
    subviews.forEach { $0.themeDidChange() }
    setNeedsLayout()
    setNeedsDisplay()
    _updateDynamicColors()
    _updateDynamicImages()
  }

  @objc func _updateDynamicColors() {
    if let dynamicBackgroundColor = _dynamicBackgroundColor {
      backgroundColor = dynamicBackgroundColor
    }
    if let dynamicTintColor = _dynamicTintColor {
      tintColor = dynamicTintColor
    }
  }

  @objc func _updateDynamicImages() {
    // For subclasses to override.
  }
}

extension UIView {
  static let swizzleWillMoveToWindowOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(willMove(toWindow:)), to: #selector(outlookWillMove(toWindow:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(willMove(toWindow:))))
    }
  }()

  @objc private dynamic func outlookWillMove(toWindow window: UIWindow?) {
    outlookWillMove(toWindow: window)
    if window != nil {
      _updateDynamicColors()
      _updateDynamicImages()
    }
  }
}

extension UIView {
  private struct Constants {
    static var dynamicBackgroundColorKey = "dynamicBackgroundColorKey"
    static var dynamicTintColorKey = "dynamicTintColorKey"
  }

  static let swizzleSetBackgroundColorOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: backgroundColor), to: #selector(outlookSetBackgroundColor)) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(setter: backgroundColor)))
    }
  }()

  static let swizzleSetTintColorOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: tintColor), to: #selector(outlookSetTintColor)) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(setter: tintColor)))
    }
  }()

  private var _dynamicBackgroundColor: DynamicColor? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicBackgroundColorKey) as? DynamicColor }
    set { objc_setAssociatedObject(self, &Constants.dynamicBackgroundColorKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  private var _dynamicTintColor: DynamicColor? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicTintColorKey) as? DynamicColor }
    set { objc_setAssociatedObject(self, &Constants.dynamicTintColorKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  @objc private dynamic func outlookSetBackgroundColor(_ color: UIColor) {
    _dynamicBackgroundColor = color as? DynamicColor
    outlookSetBackgroundColor(color)
  }

  @objc private dynamic func outlookSetTintColor(_ color: UIColor) {
    _dynamicTintColor = color as? DynamicColor
    outlookSetTintColor(color)
  }
}
