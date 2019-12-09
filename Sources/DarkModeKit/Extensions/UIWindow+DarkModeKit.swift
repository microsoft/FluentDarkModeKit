//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIWindow {
  open override func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)
    rootViewController?.dmTraitCollectionDidChange(previousTraitCollection)
  }
}
