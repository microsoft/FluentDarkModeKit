//
//  Copyright 2013-2019 Microsoft Inc.
//

extension UIImageView {

  private struct Constants {
    static var dynamicImageKey = "dynamicImageKey"
  }

  var _dynamicImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.dynamicImageKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  static let swizzleSetImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: image), to: #selector(outlookSetImage(_:))) {
      assertionFailure(DarkModeKit.messageForSwizzlingFailed(class: UIImageView.self, selector: #selector(setter: image)))
    }
  }()

  static let swizzleInitImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(UIImageView.init(image:)), to: #selector(UIImageView.outlookInit(image:))) {
      assertionFailure(DarkModeKit.messageForSwizzlingFailed(class: UIImageView.self, selector: #selector(setter: image)))
    }
  }()

  @objc dynamic func outlookInit(image: UIImage?) -> UIImageView {
    if object_getClass(image) == OLMDynamicImageProxy.self {
      _dynamicImage = image
    }
    return outlookInit(image: image)
  }

  override func _updateDynamicImages() {
    super._updateDynamicImages()

    if let dynamicImage = _dynamicImage {
      image = dynamicImage
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
}
