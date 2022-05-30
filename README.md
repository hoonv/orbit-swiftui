<div align="center">
  <a href="https://orbit.kiwi" target="_blank">
    <img alt="orbit-components" src="https://images.kiwi.com/common/orbit-logo-full.png" srcset="https://images.kiwi.com/common/orbit-logo-full@2x.png 2x" />
  </a>
</div>
<br />
<div align="center">

[![Kiwi.com library](https://img.shields.io/badge/Kiwi.com-library-00A991)](https://code.kiwi.com)
[![swiftui-version](https://img.shields.io/badge/swiftui-1.0-blue)](https://developer.apple.com/documentation/swiftui)
[![swift-version](https://img.shields.io/badge/swift-5.5-orange)](https://github.com/apple/swift)
[![swift-package-manager](https://img.shields.io/badge/package%20manager-compatible-brightgreen.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNjJweCIgaGVpZ2h0PSI0OXB4IiB2aWV3Qm94PSIwIDAgNjIgNDkiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDYzLjEgKDkyNDUyKSAtIGh0dHBzOi8vc2tldGNoLmNvbSAtLT4KICAgIDx0aXRsZT5Hcm91cDwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxnIGlkPSJQYWdlLTEiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPgogICAgICAgIDxnIGlkPSJHcm91cCIgZmlsbC1ydWxlPSJub256ZXJvIj4KICAgICAgICAgICAgPHBvbHlnb24gaWQ9IlBhdGgiIGZpbGw9IiNEQkI1NTEiIHBvaW50cz0iNTEuMzEwMzQ0OCAwIDEwLjY4OTY1NTIgMCAwIDEzLjUxNzI0MTQgMCA0OSA2MiA0OSA2MiAxMy41MTcyNDE0Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDI1IDMxIDI1IDM1IDI1IDM3IDI1IDM3IDE0IDI1IDE0IDI1IDI1Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRUZDNzVFIiBwb2ludHM9IjEwLjY4OTY1NTIgMCAwIDE0IDYyIDE0IDUxLjMxMDM0NDggMCI+PC9wb2x5Z29uPgogICAgICAgICAgICA8cG9seWdvbiBpZD0iUmVjdGFuZ2xlIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDAgMzUgMCAzNyAxNCAyNSAxNCI+PC9wb2x5Z29uPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+)](https://github.com/apple/swift-package-manager)
[![Build](https://github.com/kiwicom/orbit-swiftui/actions/workflows/ci.yml/badge.svg)](https://github.com/kiwicom/orbit-swiftui/actions/workflows/ci.yml)

  <strong>Orbit is a SwiftUI component library which provides developers the easiest possible way of building Kiwi.com’s products.</strong>

</div>

## Orbit Mission

[Orbit](https://orbit.kiwi) aims to bring order and consistency to all of our products and processes. We elevate user experience and increase the speed and efficiency of how we design and build products.

Orbit is an open-source design system created for specific needs of Kiwi.com and together with that – for needs of travel projects.

This library allows you to integrate the Orbit design system into your iOS SwiftUI project.

## Requirements

- iOS 13
- Xcode 13
- Swift Package Manager

## Installation

Add Orbit package to your project by adding the package dependency:

```swift
.package(name: "Orbit", url: "https://github.com/kiwicom/orbit-swiftui.git", .upToNextMajor(from: "0.8.0")),
```

## Usage

### Register fonts (Optional)

If you omit this optional step, Orbit components will use default iOS system fonts.

1. Define `Circular Pro` or any custom font to be used for each font weight variant. [Circular Pro must be licensed](https://orbit.kiwi/foundation/typography/circular-pro/#circular-pro-in-non-kiwicom-projects). 

```swift
Font.orbitFonts = [
    .regular: Bundle.main.url(forResource: "CircularPro-Book.otf", withExtension: nil),
    .medium: Bundle.main.url(forResource: "CircularPro-Medium.otf", withExtension: nil),
    .bold: Bundle.main.url(forResource: "CircularPro-Bold.otf", withExtension: nil)
]
```

2. Register those fonts once at app start (or use a `PreviewWrapper` wrapper for previews).

```swift
Font.registerOrbitFonts()
```

### Import Orbit package

Include Orbit package in your package or project and include `import Orbit` in SwiftUI file to access Orbit foundations and components.

![Usage in code](/Documentation/usage.png)

### Storybook catalogue screen

The `Storybook` views can be checked (using previews or an empty app) to browse a catalogue of all components. The app is also available for download on [AppStore](https://apps.apple.com/us/app/orbit-storybook/id1622225639).

```
@main struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            PreviewWrapper {
                Storybook()
            }
        }
    }
}
```

![image](/Documentation/storybook.png)

### File structure and naming conventions

File structure and component names reflect the Orbit design system structure.

- [Components](/Sources/Orbit/Components/)
- [Colors](/Sources/Orbit/Foundation/Colors/)
- [Icons](/Sources/Orbit/Foundation/Icons/)
- [Illustrations](/Sources/Orbit/Foundation/Illustrations)
- [Spacing](/Sources/Orbit/Foundation/Spacing/)

### Components

To use Orbit components in SwiftUI, import the `Orbit` library and use the components using their matching Orbit name.

```swift
import Orbit

...

VStack(spacing: .medium) {
    Heading("Messages", style: .title2)
    Illustration(.mailbox)
    Text("...<strong>...</strong>...<a href="...">here</a>.")
    Button("Continue", style: .secondary)
}
```

As some Orbit components already exist in standard SwiftUI library (`Text` and `List` for example), you can create a typealias for Orbit components to shadow these. In order to access standard components where needed, a `SwifUI.` prefix can be used to specify the native component.

```swift
// Add these lines to prefer Orbit components over SwiftUI ones
typealias Text = Orbit.Text
typealias List = Orbit.List
```

### Foundation

Most Foundation types and values are accessed using extensions on related types.

#### Spacing

Use `Spacing` enum with `CGFloat` extensions to access values.

```swift
VStack(spacing: .medium) {
    ...
}
.padding(.large)
```

#### Colors

Use `Color` and `UIColor` extensions to access values.

```swift
.foregroundColor(.cloudDarker)
```

#### Borders

Use `BorderRadius` and `BorderWidth` enums.

#### Typography

Use `Font` extensions. 
All Orbit components use the Orbit font (configured in step 0) automatically.

## Contributing

Feel free to create bug and feature requests via Issues tab.

If you want to directly contribute by fixing a bug or implementing a feature or enhancement, you are welcome to do so. Pull request review has following priorities to check:

1) API consistency with other components (similar components should have similar API)
2) Component variants matching design variants (components should have same properties as design)
3) Visual match to designs
4) Internal code structure consistency (button-like components should use consistent mechanism, haptics etc.)
5) Previews / Storybook consistency (a new component needs to be added to the Storybook)

## Feedback

We want to provide high quality and easy to use components. We can’t do that without your feedback. If you have any suggestions about what we can do to improve, please report it directly as an issue or write to us at #orbit-components on Slack.
