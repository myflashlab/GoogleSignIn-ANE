GoogleSignIn Air Native Extension

*May 24, 2020 - v4.0.2*
- Fix an issue related to Firebase dependencies.

*May 22, 2020 - v4.0.1*
- Fix a minor issue in versioning ANE.

*May 21, 2020 - v4.0.0*
- Upgrade GoogleSignin iOS SDK to v5.0.2 which is synced with Firebase ANEs collection v9.9.0.
- Adds dependencies on `AppAuth` and `GTMAppAuth` instead of the dependency on `GoogleToolboxForMac` for iOS.

*Apr 05, 2020 - V3.0.0*
- Add androidx dependencies instead of android support

*Aug 03, 2019 - V2.0.1*
* Added Android 64-bit Support
* Removed **.os** property, use `OverrideAir.os` instead

*Jun 16, 2019 - V2.0.0*
* updated Android dependencies to V16.0.1
* updated to GoogleSignin iOS SDK V4.4.0 which is synced with Firebase ANEs collection V8.x.x, you should copy the following frameworks to your ```AIR SDK/lib/aot/stub```. [Get the frameworks from Firebase iOS SDK V5.20.2](https://dl.google.com/firebase/sdk/ios/5_20_2/Firebase-5.20.2.zip).
  * Firebase/Invites/GoogleSignIn.framework
  * Firebase/Invites/GTMSessionFetcher.framework
  * Firebase/Invites/GoogleToolboxForMac.framework
* Also Make sure to replace the *GoogleSignIn.bundle* file with the latest version found at *Firebase/Invites/Resources/GoogleSignIn.bundle*
* min iOS version to support this ANE will be 10.0+ from now on.
* min Android API version to support this ANE will be 19+ from now on.

*Jan 15, 2019 - V1.4.3*
* Fixed a problem on iOS 10 and 9 which the login process didn't return the results successfully back to the AIR app

*Nov 18, 2018 - V1.4.1*
* Works with OverrideAir ANE V5.6.1 or higher
* Works with ANELAB V1.1.26 or higher

*Oct 11, 2018 - V1.4.0*
* Fixed [issue #19](https://github.com/myflashlab/GoogleSignIn-ANE/issues/19), To make sure GoogleSignIn ANE frameworks don't conflict with Firebase frameworks, we are copying dependency frameworks from Firebase instead of GoogleSignIn SDK directly.
* Remove ```GoogleSignInDependencies.framework``` from your ```AIR-SDK/lib/aot/stub```.
* Download [Firebase SDK V5.4.1](https://dl.google.com/firebase/sdk/ios/5_4_1/Firebase-5.4.1.zip) then copy the follwoing frameworks to your ```AIR-SDK/lib/aot/stub``` library.
  * Invites/GTMSessionFetcher.framework
  * Invites/GTMOAuth2.framework
  * Analytics/GoogleToolboxForMac.framework

*Sep 20, 2018 - V1.3.0*
* updated Android dependencies to V15.0.1 and replaced AndroidSupport with its sub dependencies. The ANE now depends on the following:
    * com.myflashlab.air.extensions.dependency.overrideAir
    * com.myflashlab.air.extensions.dependency.androidSupport.arch
    * com.myflashlab.air.extensions.dependency.androidSupport.core
    * com.myflashlab.air.extensions.dependency.androidSupport.v4
    * com.myflashlab.air.extensions.dependency.googlePlayServices.auth
    * com.myflashlab.air.extensions.dependency.googlePlayServices.base
    * com.myflashlab.air.extensions.dependency.googlePlayServices.basement
    * com.myflashlab.air.extensions.dependency.googlePlayServices.tasks

*Apr 22, 2018 - V1.2.0*
* updated to [iOS SDK V4.1.2](https://developers.google.com/identity/sign-in/ios/sdk/google_signin_sdk_4_1_2.zip) to be synced with Firebase ANEs V6.5.0 which uses Firebase iOS SDK V4.11.0. make sure you are updating the frameworks to this version.
* updated to Android dependencies V12.0.1 make sure you are updating the dependency ANEs to this version
* add ```android:name="android.support.multidex.MultiDexApplication"``` to the manifest main application tag to work correctly on older Android versions.

*Mar 22, 2018 - V1.1.3*
* Optimized for GoogleGamesServices V4.0.0+

*Feb 15, 2018 - V1.1.1*
* Added ```GSignIn.rest.tokenInfo``` and ```GSignIn.rest.refreshAccessToken``` to let you manage tokens easier. For more information on how to use them, read the [asdoc](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/gSignIn/GRest.html) and sample [.as codes](https://github.com/myflashlab/GoogleSignIn-ANE/blob/master/AIR/src/Main.as).
* Added [gamesSignIn](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/gSignIn/GSignInOptions.html#gamesSignIn) setter to the ```GSignInOptions``` class. Useful when you are using the [Games Services ANE](https://github.com/myflashlab/GameServices-ANE).

*Feb 12, 2018 - V1.1.0*
* Added ```GRest``` and ```GRestTokens``` classes which can be used for accesing refresh_token and access_token with the help of ```GSignIn.rest.getTokens``` method. Checkou the [Main.as](https://github.com/myflashlab/GoogleSignIn-ANE/blob/master/AIR/src/Main.as) file for usage sample.

*Jan 30, 2018 - V1.0.0*
* beginning of the journey!
