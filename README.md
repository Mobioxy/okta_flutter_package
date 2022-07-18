# okta_flutter

> Okta Flutter libary makes it easy to add authentication to your Flutter app.

This library is built on [Okta OIDC Android](https://github.com/okta/okta-oidc-android) and [Okta OIDC iOS](https://github.com/okta/okta-oidc-ios).

## Sample

You can check how to use this plugin in this sample [Futter Okta Sample](https://github.com/Mobioxy/okta_flutter_package/tree/main/example)

### Android

createOIDCConfig <br />
isAuthenticated <br />
signIn <br />
signOut <br />
refreshToken <br />
getUserProfile <br />

### iOS

createOIDCConfig <br />
isAuthenticated <br />
signIn <br />
signOut <br />
refreshToken <br />
getUserProfile <br />

## Prerequisites

- Need a **Okta Developer Account**, you can create one at [https://developer.okta.com/signup/](https://developer.okta.com/signup/).

## Add an OpenID Connect Client in Okta

In Okta, applications are OpenID Connect clients that can use Okta Authorization servers to authenticate users.
First you need to create OIDC client that will use it.

- Log in into the Okta Developer Dashboard, then click **Applications** then click on **Add Application**.
- Choose **Native** as the platform, then submit the form the default values, which should look similar to this:

| Setting             | Value                             |
| ------------------- | --------------------------------- |
| App Name            | My Native App                     |
| Login redirect URIs | com.mynativeapp:/                 |
| Grant Types Allowed | Authorization Code, Refresh Token |

After you have created the application there is some values you need to gather which will help us further:

| Setting               | Where to Find                                                                |
| --------------------- | ---------------------------------------------------------------------------- |
| Client ID             | In the applications list, or on the "General" tab of a specific application. |
| Sign-in Redirect URL  | In the applications list, or on the "General" tab of a specific application. |
| Sign-out Redirect URL | In the applications list, or on the "General" tab of a specific application. |
| App URL               | Top Right corner, Click on Username                                          |

**Note:** _As with any Okta application, make sure you assign Users or Groups to the OpenID Connect Client. Otherwise, no one can use it._

## Getting started

### Setup Android

For Android, there is one steps that you must take:

1. [Add a redirect scheme to your project.](#add-redirect-scheme)

#### Add redirect scheme

1. Defining a redirect scheme to capture the authorization redirect. In `android/app/build.gradle`, under `android` -> `defaultConfig`, add:

```
  manifestPlaceholders = [
    appAuthRedirectScheme: 'com.sampleapplication'
  ]
```

2. Make sure your `minSdkVersion` is `19`.
3. Create a proguard-rules.pro file inside the android/app folder and add the following rule

```
-ignorewarnings
-keep class com.okta.oidc.** { *; }

```

4. Add a couple of rules to the buildTypes/release block inside the app/build.gradle file

   buildTypes {
   release {
   useProguard true
   proguardFiles getDefaultProguardFile('proguard-android.txt'),
   'proguard-rules.pro'
   signingConfig signingConfigs.release
   }
   }

## Usage

You will values which we have gather in previous step.

Before calling any other method, it is important that you call `createConfig` to set up the configuration properly on the native modules.

```dart
import 'package:okta_flutter/okta_flutter.dart';

final OktaFlutter _okta = OktaFlutter.instance;
final config = OktaConfig(
    clientId: YOUR_CLIENT_ID,
    discoveryUri: YOUR_DISCOVERY_URI,
    redirectUri: YOUR_REDIRECT_URI,
    endSessionRedirectUri: YOUR_END_SESSION_REDIRECT_URI,
    scopes: ['openid', 'profile', 'email'],
);


final response = await _okta.createOIDCConfig(config);
```

### `signIn`

This method will redirect to okta´s sign in page, and will return when to the app if the user cancels the request or has error or the login was made.

```dart
await _okta.signIn()
```

### `signOut`

Clear the browser session and clear the app session (stored tokens) in memory.

```dart
await _okta.signOut();
```

### `getUserProfile`

Get Logged in User Profile User Details.

```dart
await _okta.getUserProfile()
```

### `refreshToken`

Refresh Logged in User Tokens

```dart
await _okta.refreshToken();
```

## :clap: Done

Feel free to **file a new issue** with a respective title and description on the the [okta_flutter_package](https://github.com/Mobioxy/okta_flutter_package/issues) repository. If you already found a solution to your problem, **I would love to review your pull request**!

## 📘&nbsp; License

The okta_flutter_packagee app is released under the under terms of the [MIT License](LICENSE).

## :heart: Contributor

Made by [Mobioxy](https://github.com/Mobioxy/)
