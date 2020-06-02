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
    let selector = #selector(willMove(toWindow:))
    if !dm_swizzleSelector(selector, with: { container -> Any in
      return { (self: UIView, window: UIWindow?) -> Void in
        let oldIMP = unsafeBitCast(container.imp, to: (@convention(c) (UIView, Selector, UIWindow?) -> Void).self)
        oldIMP(self, selector, window)
        if window != nil {
          self.dm_updateDynamicColors()
          self.dm_updateDynamicImages()
        }
      } as @convention(block) (UIView, UIWindow?) -> Void
    }) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: selector))
    }
  }()
}

extension UIView {
  private struct Constants {
    static var dynamicTintColorKey = "dynamicTintColorKey"
  }

  static let swizzleSetTintColorOnce: Void = {
    let selector = #selector(setter: tintColor)
    if !dm_swizzleSelector(selector, with: { container -> Any in
      return { (self: UIView, tintColor: UIColor) -> Void in
        self.dm_dynamicTintColor = tintColor as? DynamicColor
        let oldIMP = unsafeBitCast(container.imp, to: (@convention(c) (UIView, Selector, UIColor) -> Void).self)
        oldIMP(self, selector, tintColor)
      } as @convention(block) (UIView, UIColor) -> Void
    }) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: selector))
    }
  }()

  private var dm_dynamicTintColor: DynamicColor? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicTintColorKey) as? DynamicColor }
    set { objc_setAssociatedObject(self, &Constants.dynamicTintColorKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }
}
