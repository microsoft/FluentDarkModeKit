//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UITableView {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      return
    }
    else {
      dm_updateDynamicColors()

      if let dynamicSectionIndexColor = sectionIndexColor?.copy() as? DynamicColor {
        sectionIndexColor = dynamicSectionIndexColor
      }
      if let dynamicSeparatorColor = separatorColor?.copy() as? DynamicColor {
        separatorColor = dynamicSeparatorColor
      }
    }
  }
}
