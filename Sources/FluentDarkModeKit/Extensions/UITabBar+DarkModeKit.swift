//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UITabBar {
  override open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    super.dmTraitCollectionDidChange(previousTraitCollection)
    items?.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
  }

  override func dm_updateDynamicImages() {
    super.dm_updateDynamicImages()
    items?.forEach { $0._updateDynamicImages() }
  }
}

extension UITabBarItem: DMTraitEnvironment {

  private struct Constants {
    static var UIImageKey = "UIImageKey"
    static var dynamicSelectedImageKey = "dynamicSelectedImageKey"
  }

  var dm_dynamicImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.UIImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.UIImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  var dm_dynamicSelectedImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicSelectedImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.dynamicSelectedImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  static let swizzleSetImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: image), to: #selector(dm_setImage(_:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UITabBarItem.self, selector: #selector(setter: image)))
    }
  }()

  static let swizzleSetSelectedImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: selectedImage), to: #selector(dm_setSelectedImage(_:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UITabBarItem.self, selector: #selector(setter: selectedImage)))
    }
  }()

  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    // For subclasses to override
  }

  fileprivate func _updateDynamicImages() {
    if let dynamicImage = dm_dynamicImage {
      image = dynamicImage
    }

    if let dynamicImage = dm_dynamicSelectedImage {
      selectedImage = dynamicImage
    }
  }

  @objc dynamic func dm_setImage(_ image: UIImage?) {
    if object_getClass(image) == DMDynamicImageProxy.self {
      dm_dynamicImage = image
    }
    else {
      dm_dynamicImage = nil
    }
    dm_setImage(image)
  }

  @objc dynamic func dm_setSelectedImage(_ image: UIImage?) {
    if object_getClass(image) == DMDynamicImageProxy.self {
      dm_dynamicSelectedImage = image
    }
    else {
      dm_dynamicSelectedImage = nil
    }
    dm_setSelectedImage(image)
  }

}
