//
//  Copyright 2013-2019 Microsoft Inc.
//

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
