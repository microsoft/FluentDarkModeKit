//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UILabel {
  private enum Constants {
    static var currentThemeKey = "currentThemeKey"
  }

  static let swizzleDidMoveToWindowOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(didMoveToWindow), to: #selector(dm_didMoveToWindow)) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UILabel.self, selector: #selector(didMoveToWindow)))
    }
  }()

  private var currentUserInterfaceStyle: DMUserInterfaceStyle? {
    get { return objc_getAssociatedObject(self, &Constants.currentThemeKey) as? DMUserInterfaceStyle }
    set { objc_setAssociatedObject(self, &Constants.currentThemeKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  @objc private dynamic func dm_didMoveToWindow() {
    dm_didMoveToWindow()
    if currentUserInterfaceStyle != DMTraitCollection.current.userInterfaceStyle {
      currentUserInterfaceStyle = DMTraitCollection.current.userInterfaceStyle
      dmTraitCollectionDidChange(nil)
    }
  }

  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)
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
      if let color = attribute as? DynamicColor {
        if updatedAttributedText == nil {
          updatedAttributedText = NSMutableAttributedString(attributedString: attributedText)
        }
        updatedAttributedText?.setAttributes([.foregroundColor: color.copy()], range: range)
      }
    }

    if let updatedAttributedText = updatedAttributedText {
      self.attributedText = updatedAttributedText
    }
  }
}
