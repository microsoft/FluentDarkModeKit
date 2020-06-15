//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

extension UIView {
  static let swizzleWillMoveToWindowOnce: Void = {
    let selector = #selector(willMove(toWindow:))
    guard let method = class_getInstanceMethod(UIView.self, selector) else {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: selector))
      return
    }

    let imp = method_getImplementation(method)
    class_replaceMethod(UIView.self, selector, imp_implementationWithBlock({ (self: UIView, window: UIWindow?) -> Void in
      let oldIMP = unsafeBitCast(imp, to: (@convention(c) (UIView, Selector, UIWindow?) -> Void).self)
      oldIMP(self, selector, window)

      if window != nil {
        self.dm_updateDynamicColors()
        self.dm_updateDynamicImages()
      }
    } as @convention(block) (UIView, UIWindow?) -> Void), method_getTypeEncoding(method))
  }()
}
