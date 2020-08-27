![Fluent Dark Mode Kit](Assets/DarkModeKit_Masthead.png)

![](https://github.com/microsoft/FluentDarkModeKit/workflows/CI/badge.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

FluentDarkModeKit was designed and developed before Apple‘s official dark mode release. It provides a mechanism to support dark mode for apps on iOS 11+ (including iOS 13).

## Features

- [x] Dark Mode support for iOS 11+
- [x] Dynamic theme change within the app without restart
- [x] Simple API design with minimal changes to your existing code

## Installation

### Requirements

- iOS 11.0+
- Xcode 11.0+
- Swift 5.0+
- Git LFS

You can use Homebrew to install Git LFS:

```
brew install git-lfs
```

### Carthage

To integrate FluentDarkModeKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "microsoft/FluentDarkModeKit"
```

### Swift Package Manager

Click "Files -> Swift Package Manager -> Add Package Dependency..." in Xcode's menu and search "https://github.com/microsoft/FluentDarkModeKit"

Since Xcode uses its own tools to handle swifft packages, git-lfs might not be picked up if it is installed via Homebrew. Run the following command to create a symbolic link if Xcode fails to fetch the package:

```
ln -s /usr/local/bin/git-lfs $(xcode-select -p)/usr/bin/git-lfs
```

### CocoaPods

To integrate FluentDarkModeKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
pod "FluentDarkModeKit"
```

## Get Started

### How to Use FluentDarkModeKit

To set up FluentDarkModeKit, you need to call the following methods first.

```swift
let configuration = DMEnvironmentConfiguration()
// optional, register a callback for theme change
configuration.themeChangeHandler = {
    print("theme changed")
}
// optional, whether UIImageAsset is used for dynamic image
// only available for iOS 13+, images marked with "Preserve
// Vector Data" is not to be used when it is set to true,
// default to false.
configuration.useImageAsset = false

DarkModeManager.setup(with: configuration)
DarkModeManager.register(with: UIApplication.shared)
```

To use FluentDarkModeKit, provide a pair of colors or images instead of a single value. Simply replace existing colors/images with a pair of light and dark colors/images.

#### Colors

```swift
extension UIColor {
    init(_ namespace: DMNamespace, light: UIColor, dark: UIColor)
    init(_ namespace: DMNamespace, dynamicProvider: @escaping (DMTraitCollection) -> UIColor)
}

let color1 = UIColor(.dm, light: .white, dark: .black)
let color2 = UIColor(.dm) { traitCollection in
    return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
}
```

#### Images

```swift
extension UIImage {
    init(_ namespace: DMNamespace, light: UIImage, dark: UIImage)
}

let lightImage = UIImage(named: "Light")!
let darkImage = UIImage(named: "Dark")!
let image = UIImage(.dm, light: lightImage, dark: darkImage)
```

#### Change Theme

```swift
DMTraitCollection.setOverride(DMTraitCollection(userInterfaceStyle: .light), animated: true) // Change to light theme with animation
DMTraitCollection.setOverride(DMTraitCollection(userInterfaceStyle: .unspecified), animated: true) // Change to "follow system" theme
```

### Others

For more complex scenarios, FluentDarkModeKit is similar to what Apple does in iOS 13 (some slight differences). It maintains a global `DMTraitCollection` which can be accessed through `DMTraitCollection.current` during custom layout. 

For more information on cases you should handle during layout, please refer to [Apple's documentation](https://developer.apple.com/documentation/xcode/supporting_dark_mode_in_your_interface#2993898).

FluentDarkModeKit will notify views or view controllers in the current window when the theme changes by calling the following delegate method. 

```swift
protocol DMTraitEnvironment: NSObjectProtocol {
    func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?)
}
```

## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the [MIT](LICENSE) license.
