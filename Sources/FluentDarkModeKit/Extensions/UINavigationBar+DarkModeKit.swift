//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UINavigationBar {
  override func dm_updateDynamicColors() {
    super.dm_updateDynamicColors()

    if let dynamicBarTintColor = barTintColor?.copy() as? DynamicColor {
      barTintColor = dynamicBarTintColor
    }
  }
}
