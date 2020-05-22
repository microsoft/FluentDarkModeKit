//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIWindow {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)
    rootViewController?.dmTraitCollectionDidChange(previousTraitCollection)
  }
}
