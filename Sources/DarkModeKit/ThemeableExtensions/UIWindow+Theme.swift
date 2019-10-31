//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIWindow {
  override open func themeDidChange() {
    super.themeDidChange()
    rootViewController?.themeDidChange()
  }
}
