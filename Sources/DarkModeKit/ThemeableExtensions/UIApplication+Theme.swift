//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIApplication: DMTraitEnvironment {
  static var updateAppearance: ((UIApplication) -> Void)?

  open func dm_traitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    Self.updateAppearance?(self)
    windows.forEach { $0.dm_traitCollectionDidChange(previousTraitCollection) }
  }
}
