# CruiseControl 🕹️

CruiseControl is a navigation framework for SwiftUI. CruiseControl this based on Apples [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack).

## Why❔
CruiseControl is made to abstract the navigation away from the views. CruiseControl this very suiable with [MVVM](https://en.wikipedia.org/wiki/Model–view–viewmodel). With CruiseControl you are able to perform navigation from your viewModels. This facilitates more reusable and testable view/viewModel code.

## Requirements ✅
- iOS 16+

## Installation 💿

### Swift Package Manager 📦

in `Package.swift` add the following:

```swift
dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/MAChristiansen/CruiseControl", from: "1.0.0")
],
targets: [
    .target(
        name: "MyProject",
        dependencies: [..., "CruiseControl"]
    )
    ...
]
```

## Documentation 📝

### Initialisation

First, in your `@main` `App` struct file import CruiseControl.

```swift
import CruiseControl
```

Then, create a `init()` where you should call `initializeCruiseControl()`. `initializeCruiseControl()` has default parameters. If you need personal modification feel free to provide explit parameters.

```swift
import SwiftUI
import CruiseControl

@main
struct CruiseControlDemoApp: App {
    
    init() {
        initializeCruiseControl()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### CCNavigationStack Setup 🛠️

### Navigation 🗺️
