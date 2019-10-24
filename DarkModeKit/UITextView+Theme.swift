//
//  Copyright 2013-2019 Microsoft Inc.
//

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
