//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIScrollView {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

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
