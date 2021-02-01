# Hikage Finder mobile app

Mobile app of the "Hikage Finder" project.

Hikage finder navigates you in comfort even in summer days, avoiding areas with direct sunlight. Choose either the shortest route or the most shaded route to your destination.

-  Get your position with GPS
-  Follow shaded routes adjusted to the time of query

*Currently only supported in Shibuya ward, Tokyo, Japan.

## Getting Started

This project is a Flutter application. For help with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Requirements

This mobile app requires [Hikage Finder Server](https://github.com/ursci/hikagefinder-server).
The server URL needs to be configured in `lib/res/RestParams.dart`:

```
class RestParams {
  static final String baseUrl = "http://example.com:<port>/find_route";
}
```

## Build for Android

```
flutter clean
flutter channel stable
flutter pub get
flutter build appbundle --release
```

Note: Use the `ftr/release` branch for specific settings to create a signed app bundle, which requires a keystore and settings configured in `android/key.properties` as

```
storePassword=mypassword
keyPassword=mypassword
keyAlias=mykey
storeFile=/path/to/key.jks
```

## Build for iOS

[TBD]


## License

This program is free software. See [LICENSE](LICENSE) for more information.
