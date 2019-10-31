//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIPageControl {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicPageIndicatorTintColor = pageIndicatorTintColor?.copy() as? DynamicColor {
      pageIndicatorTintColor = dynamicPageIndicatorTintColor
    }
    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicCurrentPageIndicatorTintColor = currentPageIndicatorTintColor?.copy() as? DynamicColor {
      currentPageIndicatorTintColor = dynamicCurrentPageIndicatorTintColor
    }
  }
}
