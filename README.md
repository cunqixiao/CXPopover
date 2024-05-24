# CXPopover <img alt="Logo" src="/AppIcon.png" align="right" height="50">

## Summary

CXPopover is a simple popover control written in Swift. It is lightweight and easy to use. It is highly customizable and supports animations. the popover is 
the foundation of presenting anything you want in a popover style. it is easy to intergate your own content with the popover.

## Features

- [x] Flexible animations (zoom, fade, slide)
- [x] Fully customizable
- [x] Interface rotation support
- [x] Interactive presentation / dismissal support
- [x] More on the way...

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/cunqixiao/CXPopover.git", branch: "master")
```

### CocoaPods

**TBD**

## Usage

### Basic

```swift
    func presentPopover() {
        var popoverBehavior = CXPopoverBehavior.default
        popoverBehavior.anchor = .leading
        popoverBehavior.animationMetadata = .slide(moveIn: .left, moveOut: .left)
        
        let popover = CXPopoverController(popoverBehavior: popoverBehavior)
        present(popover, animated: true)
    }
```

### Other usages

**TBD**

## License

Check [LICENSE](/LICENSE) file for more information.
