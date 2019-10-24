//
//  Copyright 2013-2019 Microsoft Inc.
//

private func class_swizzleMethods(_ cls: AnyClass?, _ selector1: Selector, _ selector2: Selector) -> Bool {
  guard let method1 = class_getInstanceMethod(cls, selector1),
    let method2 = class_getInstanceMethod(cls, selector2) else {
      return false
  }

  if class_addMethod(cls, selector1, method_getImplementation(method2), method_getTypeEncoding(method2)) {
    class_replaceMethod(cls, selector2, method_getImplementation(method1), method_getTypeEncoding(method1))
  }
  else {
    method_exchangeImplementations(method1, method2)
  }

  return true
}

extension NSObject {
  @objc
  @discardableResult
  public static func dm_swizzleInstanceMethod(_ fromSelector: Selector, to toSelector: Selector) -> Bool {
    class_swizzleMethods(self, fromSelector, toSelector)
  }

  @discardableResult @objc static func dm_swizzleClassMethod(_ fromSelector: Selector, to toSelector: Selector) -> Bool {
    class_swizzleMethods(object_getClass(self), fromSelector, toSelector)
  }
}
