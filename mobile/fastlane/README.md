# Fastlane Setup

This project uses [Fastlane](https://fastlane.tools/) to automate the deployment process for Android and iOS.

## Prerequisites

1.  **Ruby**: Ensure you have Ruby installed.
2.  **Fastlane**: Install Fastlane using `gem install fastlane` or `brew install fastlane`.

## Setup

1.  Navigate to the `mobile` directory.
2.  Run `fastlane init` to configure the project (if not already fully configured).
3.  Ensure you have the necessary keys/certificates:
    *   **Android**: `key.properties` in `android/` and the upload key keystore.
    *   **iOS**: Apple Developer account credentials and signing certificates.

## Running Lanes

To deploy or run tasks, use the `fastlane` command followed by the lane name.

### Android

*   `fastlane android test`: Run unit tests.
*   `fastlane android beta`: Build and upload to Crashlytics (requires setup).
*   `fastlane android deploy`: Build App Bundle and upload to Google Play.

### iOS

*   `fastlane ios beta`: Build and upload to TestFlight.

## Note

You will need to configure `Appfile` with your specific package/bundle IDs and Apple ID to make these commands work fully.
