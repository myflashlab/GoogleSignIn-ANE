package
{
import com.doitflash.consts.Direction;
import com.doitflash.consts.Orientation;
import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
import com.doitflash.starling.utils.list.List;
import com.doitflash.text.modules.MySprite;

import com.luaye.console.C;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.InvokeEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import com.myflashlab.air.extensions.dependency.OverrideAir;
import com.myflashlab.air.extensions.gSignIn.*;


/**
 * ...
 * @author Hadi Tavakoli - 5/22/2016 11:25 AM
 */
public class Main extends Sprite
{
	private const BTN_WIDTH:Number = 150;
	private const BTN_HEIGHT:Number = 60;
	private const BTN_SPACE:Number = 2;
	private var _txt:TextField;
	private var _body:Sprite;
	private var _list:List;
	private var _numRows:int = 1;
	
	private var _serverAuthCode:String;
	private var _idToken:String;
	
	public function Main():void
	{
		Multitouch.inputMode = MultitouchInputMode.GESTURE;
		NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
		NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
		NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
		
		stage.addEventListener(Event.RESIZE, onResize);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		C.startOnStage(this, "`");
		C.commandLine = false;
		C.commandLineAllowed = false;
		C.x = 20;
		C.width = 250;
		C.height = 150;
		C.strongRef = true;
		C.visible = true;
		C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
		
		_txt = new TextField();
		_txt.autoSize = TextFieldAutoSize.LEFT;
		_txt.antiAliasType = AntiAliasType.ADVANCED;
		_txt.multiline = true;
		_txt.wordWrap = true;
		_txt.embedFonts = false;
		_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>GoogleSignIn ANE for Adobe Air V" + GSignIn.VERSION + "</font>";
		_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
		this.addChild(_txt);
		
		_body = new Sprite();
		this.addChild(_body);
		
		_list = new List();
		_list.holder = _body;
		_list.itemsHolder = new Sprite();
		_list.orientation = Orientation.VERTICAL;
		_list.hDirection = Direction.LEFT_TO_RIGHT;
		_list.vDirection = Direction.TOP_TO_BOTTOM;
		_list.space = BTN_SPACE;
		
		init();
		onResize();
	}
	
	private function onInvoke(e:InvokeEvent):void
	{
		NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
	}
	
	private function handleActivate(e:Event):void
	{
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
	}
	
	private function handleDeactivate(e:Event):void
	{
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
	}
	
	private function handleKeys(e:KeyboardEvent):void
	{
		if(e.keyCode == Keyboard.BACK)
		{
			e.preventDefault();
			NativeApplication.nativeApplication.exit();
		}
	}
	
	private function onResize(e:* = null):void
	{
		if(_txt)
		{
			_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
			
			C.x = 0;
			C.y = _txt.y + _txt.height + 0;
			C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
			C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
		}
		
		if(_list)
		{
			_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
			_list.row = _numRows;
			_list.itemArrange();
		}
		
		if(_body)
		{
			_body.y = stage.stageHeight - _body.height;
		}
	}
	
	private function init():void
	{
		// Remove OverrideAir debugger in production builds
		OverrideAir.enableDebugger(function ($ane:String, $class:String, $msg:String):void
		{
			trace($ane+" ("+$class+") "+$msg);
		});
		
		// depending on your app design, you must customize the Signin Options
		var options:GSignInOptions = new GSignInOptions();
		options.gamesSignIn = false; // (Android only) set to true if you are working with Google Games Services ANE.
		options.requestIdToken = "serverClientId"; // get the client ID of your server
		options.requestServerAuthCode = "serverClientId"; // get the client ID of your server
		options.forceCodeForRefreshToken = true;
		options.requestEmail = true;
		options.requestProfile = true;
		options.requestId = true;
		// get the iOS clientID from the .plist file you downloaded from Google when you were setting up the GSignin
		options.clientIdForiOS = "clientIdForiOS";
		
		// and pass the object to the initialization method of the ANE
		GSignIn.init(options);
		
		// If you want to access refresh_token and access_token on the client side, pass your web clientID and secret.
		GSignIn.rest.webClientId = "webClientId";
		GSignIn.rest.webClientSecret = "webClientSecret";
		
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
		
		// check if user is already loggedin or not
		var account:GAccount = GSignIn.signedInAccount;
		if(account)
		{
			showUserInfo(account);
		}
		else
		{
			// You should first check if user can signin silently, if she can't, use the signin() method
			GSignIn.silentSignIn();
		}
		
		
		//----------------------------------------------------------------------
		
		var btn0:MySprite = createBtn("signin");
		btn0.addEventListener(MouseEvent.CLICK, signin);
		_list.add(btn0);
		
		function signin(e:MouseEvent):void
		{
			if(!GSignIn.signedInAccount) GSignIn.signin();
			else C.log("You are already signed in!");
		}
		
		//----------------------------------------------------------------------
		
		var btn1:MySprite = createBtn("signout");
		btn1.addEventListener(MouseEvent.CLICK, signout);
		_list.add(btn1);
		
		function signout(e:MouseEvent):void
		{
			if(GSignIn.signedInAccount) GSignIn.signOut();
			else C.log("You are NOT signed in!");
		}
		
		//----------------------------------------------------------------------
		
		var btn2:MySprite = createBtn("revoke access");
		btn2.addEventListener(MouseEvent.CLICK, revokeAccess);
		_list.add(btn2);
		
		function revokeAccess(e:MouseEvent):void
		{
			if(GSignIn.signedInAccount) GSignIn.revokeAccess();
			else C.log("You are NOT signed in!");
		}
		
		//----------------------------------------------------------------------
		
		var btn4:MySprite = createBtn("account info");
		btn4.addEventListener(MouseEvent.CLICK, getAccountInfo);
		_list.add(btn4);
		
		function getAccountInfo(e:MouseEvent):void
		{
			var account:GAccount = GSignIn.signedInAccount;
			
			if(!account) C.log("You are not logged in!");
			else showUserInfo(account);
		}
		
		//----------------------------------------------------------------------
		
		var btn3:MySprite = createBtn("ask extra permission");
		btn3.addEventListener(MouseEvent.CLICK, askPermission);
		_list.add(btn3);
		
		function askPermission(e:MouseEvent):void
		{
			if(!GSignIn.hasPermissions([GScopes.DRIVE_APPFOLDER]))
			{
				GSignIn.requestPermissions([GScopes.DRIVE_APPFOLDER]);
			}
			else
			{
				C.log("This permission is already granted!");
			}
		}
		
		//----------------------------------------------------------------------
		
		var btn5:MySprite = createBtn("getTokens");
		btn5.addEventListener(MouseEvent.CLICK, getTokens);
		_list.add(btn5);
		
		function getTokens(e:MouseEvent):void
		{
			if(!_serverAuthCode)
			{
				C.log("serverAuthCode must be available for this method to work");
				return;
			}
			
			GSignIn.rest.getTokens(_serverAuthCode, onTokensResult);
		}
		
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
		
		//----------------------------------------------------------------------
		
		var btn6:MySprite = createBtn("tokenInfo");
		btn6.addEventListener(MouseEvent.CLICK, tokenInfo);
		_list.add(btn6);
		
		function tokenInfo(e:MouseEvent):void
		{
			if(!_idToken)
			{
				C.log("idToken must be available for this method to work");
				return;
			}
			
			GSignIn.rest.tokenInfo(_idToken, onTokensInfoResult);
		}
		
		function onTokensInfoResult($info:Object, $error:Error):void
		{
			if($error)
			{
				trace($error.message);
				return;
			}
			
			// read more about tokeninfo here:
			// https://developers.google.com/identity/sign-in/web/backend-auth#calling-the-tokeninfo-endpoint
			trace("------------------------------");
			trace(JSON.stringify($info));
			trace("------------------------------");
		}
		
		//----------------------------------------------------------------------
	}
	
	private function onRequestSuccess(e:GSignInEvents):void
	{
		C.log("----------------");
		C.log("onRequestSuccess");
		showUserInfo(e.account);
	}
	
	private function onRequestFailure(e:GSignInEvents):void
	{
		C.log("onRequestFailure: " + e.msg);
	}
	
	private function onRevokeAccessSuccess(e:GSignInEvents):void
	{
		C.log("onRevokeAccessSuccess");
	}
	
	private function onRevokeAccessFailure(e:GSignInEvents):void
	{
		C.log("onRevokeAccessFailure: " + e.msg);
	}
	
	private function onSignoutSuccess(e:GSignInEvents):void
	{
		C.log("onSignoutSuccess");
	}
	
	private function onSignoutFailure(e:GSignInEvents):void
	{
		C.log("onSignoutFailure: " + e.msg);
	}
	
	private function onSigninSuccess(e:GSignInEvents):void
	{
		C.log("----------------");
		C.log("onSigninSuccess");
		showUserInfo(e.account);
	}
	
	private function onSigninFailure(e:GSignInEvents):void
	{
		C.log("onSigninFailure: " + e.msg);
	}
	
	private function onSilentSigninSuccess(e:GSignInEvents):void
	{
		C.log("----------------");
		C.log("onSilentSigninSuccess");
		showUserInfo(e.account);
	}
	
	private function onSilentSigninFailure(e:GSignInEvents):void
	{
		/*
			check the meaning of failure code here:
			https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInStatusCodes
			https://developers.google.com/android/reference/com/google/android/gms/common/api/CommonStatusCodes
		 */
		C.log("onSilentSigninFailure: " + e.msg);
	}
	
	private function onSigninWindowStateChanged(e:GSignInEvents):void
	{
		switch(e.state)
		{
			case GSignInEvents.SIGNIN_WINDOW_ERROR:
				trace("onSigninWindowStateChanged error: " + e.msg);
				break;
			case GSignInEvents.SIGNIN_WINDOW_DISPATCH:
				trace("SIGNIN_WINDOW_DISPATCH");
				break;
		}
	}
	
	private function showUserInfo($account:GAccount):void
	{
		_serverAuthCode = $account.serverAuthCode;
		_idToken = $account.idToken;
		
		C.log("displayName: " + 	$account.displayName);
		C.log("email: " + 			$account.email);
		C.log("familyName: " + 		$account.familyName);
		C.log("givenName: " + 		$account.givenName);
		C.log("id: " + 				$account.id);
		C.log("idToken: " + 		$account.idToken);
		trace("idToken: " + 		$account.idToken);
		C.log("photoUrl: " + 		$account.photoUrl);
		for(var i:int=0; i < $account.scopes.length; i++)
		{
			C.log("\t" + $account.scopes[i]);
		}
		C.log("serverAuthCode: " + 	$account.serverAuthCode);
		trace("serverAuthCode: " + 	$account.serverAuthCode);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private function createBtn($str:String):MySprite
	{
		var sp:MySprite = new MySprite();
		sp.addEventListener(MouseEvent.MOUSE_OVER, onOver);
		sp.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		sp.addEventListener(MouseEvent.CLICK, onOut);
		sp.bgAlpha = 1;
		sp.bgColor = 0xDFE4FF;
		sp.drawBg();
		sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
		sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
		
		function onOver(e:MouseEvent):void
		{
			sp.bgAlpha = 1;
			sp.bgColor = 0xFFDB48;
			sp.drawBg();
		}
		
		function onOut(e:MouseEvent):void
		{
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
		}
		
		var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
		
		var txt:TextField = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.antiAliasType = AntiAliasType.ADVANCED;
		txt.mouseEnabled = false;
		txt.multiline = true;
		txt.wordWrap = true;
		txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
		txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
		txt.defaultTextFormat = format;
		txt.text = $str;
		
		txt.y = sp.height - txt.height >> 1;
		sp.addChild(txt);
		
		return sp;
	}
}
	
}