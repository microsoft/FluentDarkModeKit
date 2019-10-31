//
//  Copyright 2013-2019 Microsoft Inc.
//

import UIKit

extension UIWindow {
  override open func themeDidChange() {
    super.themeDidChange()
    rootViewController?.themeDidChange()
  }
}
