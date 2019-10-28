//
//  Copyright 2013-2019 Microsoft Inc.
//

extension UIViewController: Themeable {
  @objc open func themeDidChange() {
    setNeedsStatusBarAppearanceUpdate()
    presentedViewController?.themeDidChange()
    children.forEach { $0.themeDidChange() }
    if isViewLoaded {
      view.themeDidChange()
    }
  }
}
