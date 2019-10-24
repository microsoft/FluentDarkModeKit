//
//  Copyright 2013-2019 Microsoft Inc.
//

extension UITabBar {
  override open func themeDidChange() {
    super.themeDidChange()
    items?.forEach { $0.themeDidChange() }
  }

  override func _updateDynamicImages() {
    super._updateDynamicImages()
    items?.forEach { $0._updateDynamicImages() }
  }
}

extension UITabBarItem: Themeable {

  private struct Constants {
    static var UIImageKey = "UIImageKey"
    static var dynamicSelectedImageKey = "dynamicSelectedImageKey"
  }

  var _dynamicImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.UIImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.UIImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  var _dynamicSelectedImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicSelectedImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.dynamicSelectedImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  static let swizzleSetImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: image), to: #selector(outlookSetImage(_:))) {
      assertionFailure(DarkModeKit.messageForSwizzlingFailed(class: UITabBarItem.self, selector: #selector(setter: image)))
    }
  }()

  static let swizzleSetSelectedImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: selectedImage), to: #selector(outlookSetSelectedImage(_:))) {
      assertionFailure(DarkModeKit.messageForSwizzlingFailed(class: UITabBarItem.self, selector: #selector(setter: selectedImage)))
    }
  }()

  @objc open func themeDidChange() {
    // For subclasses to override
  }

  fileprivate func _updateDynamicImages() {
    if let dynamicImage = _dynamicImage {
      image = dynamicImage
    }

    if let dynamicImage = _dynamicSelectedImage {
      selectedImage = dynamicImage
    }
  }

  @objc dynamic func outlookSetImage(_ image: UIImage?) {
    if object_getClass(image) == OLMDynamicImageProxy.self {
      _dynamicImage = image
    }
    else {
      _dynamicImage = nil
    }
    outlookSetImage(image)
  }

  @objc dynamic func outlookSetSelectedImage(_ image: UIImage?) {
    if object_getClass(image) == OLMDynamicImageProxy.self {
      _dynamicSelectedImage = image
    }
    else {
      _dynamicSelectedImage = nil
    }
    outlookSetSelectedImage(image)
  }

}
