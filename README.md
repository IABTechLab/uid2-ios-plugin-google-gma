# UID2 Google GMA iOS Plugin

A plugin for integrating [UID2](https://github.com/IABTechLab/uid2docs) and [Google GMA](https://developers.google.com/admob/ios/quick-start) into iOS applications.

[![License: Apache](https://img.shields.io/badge/License-Apache-green.svg)](https://www.apache.org/licenses/)
[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://img.shields.io/badge/Swift-5-orange)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-blue)](https://img.shields.io/badge/Swift_Package_Manager-compatible-blue)


## Integration Guide

For the latest instructions on how to use this plugin, refer to the [UID2 GMA Plugin for iOS Integration Guide](https://unifiedid.com/docs/guides/mobile-plugin-gma-ios).

## Repository Structure

```
.
├── Development
│   ├── UID2GoogleGMADevelopmentApp
│   └── UID2GoogleGMADevelopmentApp.xcodeproj
├── Package.swift
├── LICENSE.md
├── README.md
├── Sources
│   └── UID2GMAPlugin
└── Tests
    └── UID2GMAPluginTests
```

## Requirements

* Xcode 15.0+

| Platform | Minimum target | Swift Version |
| --- | --- | --- |
| iOS | 13.0+ | 5.0+ |

## Development

The UID2GMAPlugin is a standalone headless library defined and managed by the Swift Package Manager via `Package.swift`.  As such the `UID2GoogleGMADevelopmentApp` is the primary way for developing the SDK.  Use Xcode to open `Development/UID2GoogleGMADevelopmentApp/UID2GoogleGMADevelopmentApp.xcodeproj` to begin development.

## License

UID2 is released under the Apache V2 license. [See LICENSE](https://github.com/IABTechLab/uid2-ios-sdk/blob/main/LICENSE.md) for details.
