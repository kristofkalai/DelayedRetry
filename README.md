# DelayedRetry
Combine's retry operator has got some new fancy way of customization! 🎩

## Setup

Add the following to `Package.swift`:

```swift
.package(url: "https://github.com/stateman92/DelayedRetry", exact: .init(0, 0, 1))
```

[Or add the package in Xcode.](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

## Usage

Use the `delayedRetry(count:delay:transform:)` method on any `Publisher`. The more preferred way is to use the `dataTaskWithDelayedRetry(url:count:delay:transform:)` method on a `URLSession`.

For details see the Example app.
