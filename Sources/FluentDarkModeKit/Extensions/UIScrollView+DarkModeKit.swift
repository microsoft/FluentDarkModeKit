//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIScrollView {
  override func dm_updateDynamicColors() {
    super.dm_updateDynamicColors()

    indicatorStyle = {
      if DMTraitCollection.current.userInterfaceStyle == .dark {
        return .white
      }
      else {
        return .default
      }
    }()
  }
}
