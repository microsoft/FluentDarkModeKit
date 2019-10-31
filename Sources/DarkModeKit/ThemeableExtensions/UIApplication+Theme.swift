//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIApplication: Themeable {
  static var updateAppearance: ((UIApplication) -> Void)?

  @objc open func themeDidChange() {
    Self.updateAppearance?(self)
    windows.forEach { $0.themeDidChange() }
  }
}
