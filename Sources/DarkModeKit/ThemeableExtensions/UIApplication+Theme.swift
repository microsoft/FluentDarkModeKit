//
//  Copyright 2013-2019 Microsoft Inc.
//

extension UIApplication: Themeable {
  static var updateAppearance: ((UIApplication) -> Void)?

  @objc open func themeDidChange() {
    Self.updateAppearance?(self)
    windows.forEach { $0.themeDidChange() }
  }
}
