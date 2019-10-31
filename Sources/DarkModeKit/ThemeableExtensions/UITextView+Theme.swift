//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UITextView {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    keyboardAppearance = {
      if DMTraitCollection.current.userInterfaceStyle == .dark {
        return .dark
      }
      else {
        return .default
      }
    }()
  }
}
