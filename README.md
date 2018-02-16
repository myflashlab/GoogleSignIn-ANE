# GoogleSignIn ANE V1.1.1 for Android+iOS
This AIR Native Extension will let your app user to sign-in to your app using their Google account. It also lets you specify what kind of permissions your app may need.

**Main Features:**

* SignIn/out from Google account.
* Silent Sign-In feature to make sure users are signed in your app when relaunching the app.
* Option for accessing the refresh_token and access_token
* Option for requesting extra permissions when necessary.
* Option for revoking access to the requested permissions.
* Option for enabling Server-Side Access.
* Option to authenticate with a backend server.

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/gSignIn/package-detail.html)

[Download demo ANE](https://github.com/myflashlab/GoogleSignIn-ANE/tree/master/AIR/lib)

# Configure GSignin on Google API Console
For Android, visit [this page](https://developers.google.com/identity/sign-in/android/start-integrating#configure_a_console_name_project) and click on the button **Configure a project** to start setting up your API. notice that AIR will add *air.* at the beginning of your app package name.  
For iOS, visit [here](https://developers.google.com/identity/sign-in/ios/start-integrating#get-config) and click on the button **Get a Configuration File**.

# AIR Usage
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/GoogleSignIn-ANE/blob/master/AIR/src/Main.as).

```actionscript
import com.myflashlab.air.extensions.gSignIn.*;

// depending on your app design, you must customize the Signin Options
var options:GSignInOptions = new GSignInOptions();
options.gamesSignIn = false; // (Android only) set to true if you are working with Google Games Services ANE.
options.requestIdToken ="serverClientId"; // get the client ID of your server
options.requestServerAuthCode = "serverClientId"; // get the client ID of your server
options.requestEmail = true;
options.requestProfile = true;
options.requestId = true;
// get the iOS clientID from the .plist file you downloaded when you were setting up the GSignin
options.clientIdForiOS = "clientIdForiOS";

// and pass the object to the initialization method of the ANE
GSignIn.init(options);

// If you want to access refresh_token and access_token on the client side, pass your web clientID and secret.
GSignIn.rest.webClientId = "WebClientId";
GSignIn.rest.webClientSecret = "WebClientSecret";

// Then, add listeners
GSignIn.listener.addEventListener(GSignInEvents.SILENT_SIGNIN_SUCCESS, onSilentSigninSuccess);
GSignIn.listener.addEventListener(GSignInEvents.SILENT_SIGNIN_FAILURE, onSilentSigninFailure);
GSignIn.listener.addEventListener(GSignInEvents.SIGNIN_SUCCESS, onSigninSuccess);
GSignIn.listener.addEventListener(GSignInEvents.SIGNIN_FAILURE, onSigninFailure);
GSignIn.listener.addEventListener(GSignInEvents.SIGNOUT_SUCCESS, onSignoutSuccess);
GSignIn.listener.addEventListener(GSignInEvents.SIGNOUT_FAILURE, onSignoutFailure);
GSignIn.listener.addEventListener(GSignInEvents.REVOKE_ACCESS_SUCCESS, onRevokeAccessSuccess);
GSignIn.listener.addEventListener(GSignInEvents.REVOKE_ACCESS_FAILURE, onRevokeAccessFailure);
GSignIn.listener.addEventListener(GSignInEvents.REQUEST_PERMISSION_SUCCESS, onRequestSuccess);
GSignIn.listener.addEventListener(GSignInEvents.REQUEST_PERMISSION_FAILURE, onRequestFailure);

// on iOS you may optionally add the following listener to know the state of the login window
GSignIn.listener.addEventListener(GSignInEvents.LOGIN_WINDOW_STATUS, onSigninWindowStateChanged);

// check if user is already logged-in or not
var account:GAccount = GSignIn.signedInAccount;
if(account)
{
	showUserInfo(account);
}
else
{
	// You should first check if user can signin silently, if she can't, use the GSignIn.signin() method
	GSignIn.silentSignIn();
}

private function onSilentSigninSuccess(e:GSignInEvents):void
{
	showUserInfo(e.account);
}

private function onSilentSigninFailure(e:GSignInEvents):void
{
	/*
		check the meaning of failure code here:
		https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInStatusCodes
		https://developers.google.com/android/reference/com/google/android/gms/common/api/CommonStatusCodes
	 */
	trace("onSilentSigninFailure: " + e.msg);

	// if silent signin can't happen, it means that this is the first time that user is using the app
	// it may also mean that the user has signed out or revoked access the last time she has been using the app.
	// in such cases, you must create a signin button and when that is clicked, you must call:
	// GSignIn.signin();
}

private function onSigninSuccess(e:GSignInEvents):void
{
	showUserInfo(e.account);
}

private function onSigninFailure(e:GSignInEvents):void
{
	trace("onSigninFailure: " + e.msg);
}

private function showUserInfo($account:GAccount):void
{
	trace("displayName: " + 	$account.displayName);
	trace("email: " + 			$account.email);
	trace("familyName: " + 		$account.familyName);
	trace("givenName: " + 		$account.givenName);
	trace("id: " + 				$account.id);
	trace("idToken: " + 			$account.idToken);
	trace("photoUrl: " + 		$account.photoUrl);
	for(var i:int=0; i < $account.scopes.length; i++)
	{
		trace("\t" + $account.scopes[i]);
	}
	trace("serverAuthCode: " + 	$account.serverAuthCode);

	// when you receive the serverAuthCode, you can request for refresh_token like below.
	// However, it is recommended that you pass the serverAuthCode to your server and do 
	// this on server side.
	GSignIn.rest.getTokens($account.serverAuthCode, onTokensResult);

	function onTokensResult($restTokens:GRestTokens, $error:Error):void
	{
		if($error)
		{
			trace($error.message);
			return;
		}
		
		trace("------------------------------");
		trace("access_token: " + 	$restTokens.access_token);
		trace("token_type: " + 		$restTokens.token_type);
		trace("expires_in: " + 		$restTokens.expires_in);
		trace("refresh_token: " + 	$restTokens.refresh_token);
		trace("id_token: " + 		$restTokens.id_token);
		trace("------------------------------");
	}
}
```

# Air .xml manifest
```xml
<!--
FOR ANDROID:
-->
<manifest android:installLocation="auto">
	
	<uses-permission android:name="android.permission.INTERNET" />
	<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
	<uses-sdk android:targetSdkVersion="23"/>
	
	<application>
		
		<activity 
			android:name="com.google.android.gms.auth.api.signin.internal.SignInHubActivity"
			android:theme="@android:style/Theme.Translucent.NoTitleBar"
			android:excludeFromRecents="true" android:exported="false"/>
			
		<service android:name="com.google.android.gms.auth.api.signin.RevocationBoundService"
			android:exported="true"
			android:permission="com.google.android.gms.auth.api.signin.permission.REVOCATION_NOTIFICATION"/>

		<activity 
			android:name="com.google.android.gms.common.api.GoogleApiActivity" 
			android:theme="@android:style/Theme.Translucent.NoTitleBar" 
			android:exported="false"/>

		<meta-data 
			android:name="com.google.android.gms.version" 
			android:value="@integer/google_play_services_version"/>
		
	</application>
</manifest>






<!--
FOR iOS:
-->
	<!--iOS 9.0 or higher can support this ANE-->
	<key>MinimumOSVersion</key>
	<string>9.0</string>
	
	<key>CFBundleURLTypes</key>
		<array>
			<dict>
				<key>CFBundleTypeRole</key>
				<string>Editor</string>
				<key>CFBundleURLName</key>
				<string>google</string>
				<key>CFBundleURLSchemes</key>
				<array>
					<!-- open the .plist file you downloaded from Google and find value for  REVERSED_CLIENT_ID -->
					<string>[REVERSED_CLIENT_ID]</string>
				</array>
			</dict>
		</array>
	
	
	
	
	
<!--
Embedding the ANE:
-->
  <extensions>
        <extensionID>com.myflashlab.air.extensions.google.signin</extensionID>

        <!-- Download dependency ANEs from https://github.com/myflashlab/common-dependencies-ANE -->
        <extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.androidSupport</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.auth</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.auth.base</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.base</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.basement</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.tasks</extensionID>
  </extensions>
-->
```

# Requirements
* This ANE is dependent on the following ANEs, found [here](https://github.com/myflashlab/common-dependencies-ANE).
  * androidSupport.ane
  * overrideAir.ane
  * googlePlayServices_auth.ane
  * googlePlayServices_authBase.ane
  * googlePlayServices_base.ane
  * googlePlayServices_basement.ane
  * googlePlayServices_tasks.ane
* Even if you are building for iOS only, you'd still need **overrideAir.ane**.
* On the iOS side, you need to make sure you have included the resource, "GoogleSignIn.bundle" at the root of you package. 
* On the iOS side, you will need **GoogleSignIn.framework** and **GoogleSignInDependencies.framework** available in your *AIR_SDK/lib/aot/stub* folder. Download them from [this package - GSignin SDK V4.1.1](https://developers.google.com/identity/sign-in/ios/sdk/google_signin_sdk_4_1_1.zip).
* Android API 15 or higher
* iOS SDK 9.0 or higher
* AIR SDK 28.0

# Permissions
If you are targeting AIR 24 or higher, you need to [take care of the permissions manually](http://www.myflashlabs.com/adobe-air-app-permissions-android-ios/). Below are the list of Permissions this ANE might require. (Note: *Necessary Permissions* are those that the ANE will NOT work without them and *Optional Permissions* are those which are needed only if you are using some specific features in the ANE.)

Check out the demo project available at this repository to see how we have used our [PermissionCheck ANE](http://www.myflashlabs.com/product/native-access-permission-check-settings-menu-air-native-extension/) to ask for the permissions.

**Necessary Permissions:**  
none

**Optional Permissions:**  
none

# Commercial Version
http://www.myflashlabs.com/product/google-signin-ane-adobe-air-native-extension/

![google-signin ANE](http://www.myflashlabs.com/wp-content/uploads/2018/01/product_adobe-air-ane-google-signin-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
*Feb 15, 2018 - V1.1.1*
* Added ```GSignIn.rest.tokenInfo``` and ```GSignIn.rest.refreshAccessToken``` to let you manage tokens easier. For more information on how to use them, read the [asdoc](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/gSignIn/GRest.html) and sample [.as codes](https://github.com/myflashlab/GoogleSignIn-ANE/blob/master/AIR/src/Main.as).
* Added [gamesSignIn](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/gSignIn/GSignInOptions.html#gamesSignIn) setter to the ```GSignInOptions``` class. Useful when you are using the [Games Services ANE](https://github.com/myflashlab/GameServices-ANE).

*Feb 12, 2018 - V1.1.0*
* Added ```GRest``` and ```GRestTokens``` classes which can be used for accesing refresh_token and access_token with the help of ```GSignIn.rest.getTokens``` method. Checkou the [Main.as](https://github.com/myflashlab/GoogleSignIn-ANE/blob/master/AIR/src/Main.as) file for usage sample.

*Jan 30, 2018 - V1.0.0*
* beginning of the journey!