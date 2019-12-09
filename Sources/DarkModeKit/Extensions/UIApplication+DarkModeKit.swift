//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIApplication: DMTraitEnvironment {
  static var updateAppearance: ((UIApplication) -> Void)?

  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    Self.updateAppearance?(self)
    windows.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
  }
}
