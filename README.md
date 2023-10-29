# CruiseControl 🕹️

CruiseControl is a navigation framework for SwiftUI. CruiseControl this based on Apples [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack).

## Why❔
CruiseControl is made to abstract the navigation away from the views. CruiseControl this very suiable with [MVVM](https://en.wikipedia.org/wiki/Model–view–viewmodel). With CruiseControl you are able to perform navigation from your `ViewModel`s. This facilitates more reusable and testable `View`/`ViewModel` code.

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

First, in your `@main` `App` file import CruiseControl.

```swift
import CruiseControl
```

Then, create a `init()` where you call `initializeCruiseControl()`. `initializeCruiseControl()` has default parameters. Feel free to override the default parameter to fit your needs.

```swift
init() {
    initializeCruiseControl()
}
```

You should end up with a `@main` `App` like:


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
            MainView()
        }
    }
}
```

❗️Note: It is important you call `initializeCruiseControl()` before creating your first view. This function will set up the navigation service that will take care of upcoming navigation.

### CCNavigationStack Setup 🛠️

To create your navigation stack you need to define the destinations for the given stack. You do that by conform to `CCDestination`. CruiseControl recomment to create a `enum` type that conforms to `CCDestination` like:

```swift
import SwiftUI
import CruiseControl

enum MainDestinations: CCDestination {
    case red
    case blue
    case yellow
    case green
    case redSheet
    
    @ViewBuilder
    func buildView() -> some View {
        switch self {
        case .red:
            ColorView(viewModel: .red)
        case .blue:
            ColorView(viewModel: .blue)
        case .yellow:
            ColorView(viewModel: .yellow)
        case .green:
            ColorView(viewModel: .green)
        case .redSheet:
            ColorView(viewModel: .redSheet)
        }
    }
}
```

Now you are ready to initate your navigation stack.
With your navigation stack you can create your navigation view with `CCNavigationView.`

```swift
import SwiftUI
import CruiseControl

struct MainView: View {
    var body: some View {
        CCNavigationView(navigationStack: CCNavigationStack<MainDestinations>()) {
            MainRootView()
        }
    }
}
```
Above we create a navigation view with a navigation stack with destinations as `MainDestinations`.
Now you are ready to navigate!

### Navigation 🗺️

To navitage you have to use the global `navigationService` variable. All the navigation actions will be executed on the navigation stack with the according destination type. Don't worry - the `CCNavigationService` will take care of that!

#### Push 🫸🏼
To push a view on the navigation stack use following:

```swift
navigationService?.push(MainDestinations.red)
```

To push multiple views on the navigation stack use following:

```swift
navigationService?.push([MainDestinations.blue, .yellow])
```

#### Create/Replace stack 🔨
To create or replace the stack use following:

```swift
navigationService?.createStack([MainDestinations.red, .yellow, .blue])
```

#### Pop 🫷🏼
To pop a view from the stack use following:

```swift
navigationService?.pop(MainDestinations.self)
```

To pop to a specific destinations in the stack use following:

```swift
navigationService?.pop(to: MainDestinations.red)
```

To pop to root of the stack use following:
                
```swift
navigationService?.popToRoot(MainDestinations.self)
```

#### Sheet 📃
To present a sheet use following:

```swift
navigationService?.display(MainDestinations.redSheet)
```
Be aware that you can push what every view on to the sheet. In this case we have just named it `redSheet` to make a specific view for the Sheet demo.
Note: You can't display a sheet on a sheet.

To dismiss the sheet use following:

```swift
navigationService?.dismissSheet(MainDestinations.self)
```

#### System Alert 🚨
To display a system alert use following:

```swift
DemoButtonViewModel(title: "Display Demo Alert 🚨") {
    navigationService?.display(
        MainDestinations.self,
        alertModel: AlertModel(
            title: "Demo Title",
            message: "This is a demo alert!",
            buttons: [
                AlertButton(title: "Close", role: .cancel, action: {
                    navigationService?.dismissAlert(MainDestinations.self)
                })
            ]
        )
    )
}
```

To dismiss a system alert use following:

```swift
navigationService?.dismissAlert(MainDestinations.self)
```

## Example Apps
Find CruiseControl in action in following projects:

- [Color Navigation](https://github.com/MAChristiansen/ColorNavigation)

## License
MIT license. See the [LICENSE](https://github.com/MAChristiansen/CruiseControl/blob/main/LICENSE) file for details.
