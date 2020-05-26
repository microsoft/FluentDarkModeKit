//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIView: DMTraitEnvironment {
  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    subviews.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
    setNeedsLayout()
    setNeedsDisplay()
    dm_updateDynamicColors()
    dm_updateDynamicImages()
  }

  @objc func dm_updateDynamicColors() {
    if let dynamicBackgroundColor = dm_dynamicBackgroundColor {
      backgroundColor = dynamicBackgroundColor
    }
    if let dynamicTintColor = dm_dynamicTintColor {
      tintColor = dynamicTintColor
    }
  }

  @objc func dm_updateDynamicImages() {
    // For subclasses to override.
  }
}

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
  private struct Constants {
    static var dynamicTintColorKey = "dynamicTintColorKey"
  }

  static let swizzleSetTintColorOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: tintColor), to: #selector(dm_setTintColor)) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(setter: tintColor)))
    }
  }()

  private var dm_dynamicTintColor: DynamicColor? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicTintColorKey) as? DynamicColor }
    set { objc_setAssociatedObject(self, &Constants.dynamicTintColorKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  @objc private dynamic func dm_setTintColor(_ color: UIColor) {
    dm_dynamicTintColor = color as? DynamicColor
    dm_setTintColor(color)
  }
}
