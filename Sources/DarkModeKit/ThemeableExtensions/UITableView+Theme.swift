//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UITableView {
  override func _updateDynamicColors() {
    super._updateDynamicColors()

    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicSectionIndexColor = sectionIndexColor?.copy() as? DynamicColor {
      sectionIndexColor = dynamicSectionIndexColor
    }
    // swiftlint:disable:next prefer_type_safe_clone
    if let dynamicSeparatorColor = separatorColor?.copy() as? DynamicColor {
      separatorColor = dynamicSeparatorColor
    }
  }
}
