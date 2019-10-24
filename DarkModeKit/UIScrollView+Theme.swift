//
//  Copyright 2013-2019 Microsoft Inc.
//

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
