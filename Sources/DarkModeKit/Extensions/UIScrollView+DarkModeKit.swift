//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIScrollView {
  override func dm_updateDynamicColors() {
    super.dm_updateDynamicColors()

    indicatorStyle = {
      if DMTraitCollection.current.userInterfaceStyle == .dark {
        return .black
      }
      else {
        return .default
      }
    }()
  }
}
