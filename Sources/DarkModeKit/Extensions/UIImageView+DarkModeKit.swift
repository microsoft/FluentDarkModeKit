//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIImageView {

  private struct Constants {
    static var dynamicImageKey = "dynamicImageKey"
  }

  var dmDynamicImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.dynamicImageKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  static let swizzleSetImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: image), to: #selector(dm_setImage(_:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIImageView.self,
                                                                 selector: #selector(setter: image)))
    }
  }()

  static let swizzleInitImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(UIImageView.init(image:)), to: #selector(UIImageView.dm_init(image:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIImageView.self,
                                                                 selector: #selector(setter: image)))
    }
  }()

  @objc dynamic func dm_init(image: UIImage?) -> UIImageView {
    if object_getClass(image) == DMDynamicImageProxy.self {
      dmDynamicImage = image
    }
    return dm_init(image: image)
  }

  override func dm_updateDynamicImages() {
    super.dm_updateDynamicImages()

    if let dynamicImage = dmDynamicImage {
      image = dynamicImage
    }
  }

  @objc dynamic func dm_setImage(_ image: UIImage?) {
    if object_getClass(image) == DMDynamicImageProxy.self {
      dmDynamicImage = image
    } else {
      dmDynamicImage = nil
    }
    dm_setImage(image)
  }
}
