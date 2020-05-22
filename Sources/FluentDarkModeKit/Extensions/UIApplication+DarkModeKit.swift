//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIApplication: DMTraitEnvironment {
  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    windows.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
  }
}
