//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIView: DMTraitEnvironment {
  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    subviews.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
    setNeedsLayout()
    setNeedsDisplay()
    dm_updateDynamicColors()
    _updateDynamicImages()
  }

  @objc func dm_updateDynamicColors() {
    if let dynamicBackgroundColor = dm_dynamicBackgroundColor {
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
      dm_updateDynamicColors()
      _updateDynamicImages()
    }
  }
}

extension UIView {
  private struct Constants {
    static var dynamicTintColorKey = "dynamicTintColorKey"
  }

  static let swizzleSetTintColorOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: tintColor), to: #selector(outlookSetTintColor)) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(setter: tintColor)))
    }
  }()

  private var _dynamicTintColor: DynamicColor? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicTintColorKey) as? DynamicColor }
    set { objc_setAssociatedObject(self, &Constants.dynamicTintColorKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  @objc private dynamic func outlookSetTintColor(_ color: UIColor) {
    _dynamicTintColor = color as? DynamicColor
    outlookSetTintColor(color)
  }
}
