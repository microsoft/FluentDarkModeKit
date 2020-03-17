//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIPageControl {
  override func dm_updateDynamicColors() {
    super.dm_updateDynamicColors()
    
    if let dynamicPageIndicatorTintColor = pageIndicatorTintColor?.copy() as? DynamicColor {
      pageIndicatorTintColor = dynamicPageIndicatorTintColor
    }
    if let dynamicCurrentPageIndicatorTintColor = currentPageIndicatorTintColor?.copy() as? DynamicColor {
      currentPageIndicatorTintColor = dynamicCurrentPageIndicatorTintColor
    }
  }
}
