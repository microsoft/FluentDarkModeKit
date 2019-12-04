//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIWindow {
  open override func dm_traitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dm_traitCollectionDidChange(previousTraitCollection)
    rootViewController?.dm_traitCollectionDidChange(previousTraitCollection)
  }
}
