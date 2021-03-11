//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIPageControl {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }
    else {
      dm_updateDynamicColors()

      if let dynamicPageIndicatorTintColor = pageIndicatorTintColor?.copy() as? DynamicColor {
        pageIndicatorTintColor = dynamicPageIndicatorTintColor
      }
      if let dynamicCurrentPageIndicatorTintColor = currentPageIndicatorTintColor?.copy() as? DynamicColor {
        currentPageIndicatorTintColor = dynamicCurrentPageIndicatorTintColor
      }
    }
  }
}
