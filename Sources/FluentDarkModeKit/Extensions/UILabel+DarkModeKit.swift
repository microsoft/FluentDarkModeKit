//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UILabel {
  private enum Constants {
    static var currentThemeKey = "currentThemeKey"
  }

  static let swizzleDidMoveToWindowOnce: Void = {
    let selector = #selector(didMoveToWindow)
    guard let method = class_getInstanceMethod(UILabel.self, selector) else {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UILabel.self, selector: selector))
      return
    }

    let imp = method_getImplementation(method)
    class_replaceMethod(UILabel.self, selector, imp_implementationWithBlock({ (self: UILabel) -> Void in
        let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UILabel, Selector) -> Void).self)
        oldIMP(self, selector)
        if self.currentUserInterfaceStyle != DMTraitCollection.override.userInterfaceStyle {
          self.currentUserInterfaceStyle = DMTraitCollection.override.userInterfaceStyle
          self.dmTraitCollectionDidChange(nil)
        }
      } as @convention(block) (UILabel) -> Void), method_getTypeEncoding(method))
  }()

  private var currentUserInterfaceStyle: DMUserInterfaceStyle? {
    get { return objc_getAssociatedObject(self, &Constants.currentThemeKey) as? DMUserInterfaceStyle }
    set { objc_setAssociatedObject(self, &Constants.currentThemeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }

    guard #available(iOS 12.0, *) else {
      // Fix for iOS 11.x
      updateDynamicColorInAttributedText()
      return
    }
  }

  private func updateDynamicColorInAttributedText() {
    guard let attributedText = attributedText else {
      return
    }

    // Why are we doing this?
    //
    // 1. In iOS 11, setNeedsDisplay() is not work well
    // 2. If you set UILabel.attributedText, UILabel.textColor will be foreground color at index 0 of the attributed text
    // 3. If you set UILabel.textColor, the entire attributed text will get a foreground color
    // 4. So if a label has a two or more colors attributed string, we can not simply reset text color
    // 5. The final solution is in below, we just update attributed text
    // 6. Luckliy we only need to do this in iOS 11.

    var updatedAttributedText: NSMutableAttributedString?

    var range = NSRange(location: 0, length: 0)
    while range.location + range.length < attributedText.length {
      let index = range.location + range.length
      // Don't panic, this call just make range an inout parameter.
      let attribute = withUnsafeMutablePointer(to: &range) {
        attributedText.attribute(.foregroundColor, at: index, effectiveRange: $0)
      }
      if updatedAttributedText == nil {
        updatedAttributedText = NSMutableAttributedString(attributedString: attributedText)
      }
      if let color = attribute as? DynamicColor {
        updatedAttributedText?.addAttribute(.foregroundColor, value: color.copy(), range: range)
      }
      else if let color = textColor as? DynamicColor {
        updatedAttributedText?.addAttribute(.foregroundColor, value: color.copy(), range: range)
      }
    }

    if let updatedAttributedText = updatedAttributedText {
      self.attributedText = updatedAttributedText
    }
  }
}
