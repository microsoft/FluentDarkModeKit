//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UITextView {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }
    else {
      dm_updateDynamicColors()

      keyboardAppearance = {
        if DMTraitCollection.override.userInterfaceStyle == .dark {
          return .dark
        }
        else {
          return .default
        }
      }()
    }
  }
}
