ContactAtOnce Messaging iOS SDK
==============

Framework enabling apps to integrate ContactAtOnce messaging with an easy-to-use API. To learn more about ContactAtOnce and the messaging service, visit https://ContactAtOnce.com

## Prerequisites

* iOS 10.3 or later
* XCode 10.x
* Swift 4.2

## Installation

### Step 1

Because of the dependencies required for the framework, we strongly encourage the use of CocoaPods on your iOS project. CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects. CocoaPods has thousands of libraries and is used in over 2 million apps. It can help you scale your projects elegantly and provides a standard format for managing external libraries.

 1. Install cocoapods using the following command:
```
	$ gem install cocoapods
```
 2. Navigate to your project folder and init new pod using the following command:
```
	$ pod init
```
 3. Podfile should be created under your project’s folder.
 To integrate ContactAtOnce Messaging SDK into your Xcode project using CocoaPods, specify the dependencies in your Podfile:
```
	platform :ios, '10.3'
	use_frameworks!

	target '<Your Target Name>' do
		pod 'TTTAttributedLabel', '~> 2.0'
		pod 'SLXMPPFramework', '~> 4.0'
		pod 'Promises', '~> 2.0'
		pod 'RNCryptor', '~> 5.0'
		pod 'ReachabilitySwift', '~> 4.3'
	end
```

 4. Run the following command in the terminal under your project folder:
```
	$ pod install
```
 5. Whenever you wish to upgrade to the latest SDK version and you have already ran 'pod install', Run the following command:
```
 $ pod update
```

 6. Open the .xcworkspace file and select your target.
 
 7. Drag the `ContactAtOnceMessaging.framework` file to the area called `Embedded Libraries` under General. Make sure Copy Items if needed is checked.
 



### Step 2

Some XCode Project's Capabilities need to be switched on in order to support SDK specific features.
In XCode, navigate to project's Targets settings and select the relevant target of your app, then navigate to 'Capabilities' tab.
 * **Push Notifications**: The SDK uses remote push notification to notify the user whenever a new message from remote user has been received. To use remote push notifications, switch on 'Push Notifications' toggle.


## License

All usage of the contents, documentation or code found in this repository is subject to the [LivePerson API Terms of Use](https://www.liveperson.com/policies/apitou). Please use the link above to read them carefully before utilizing the site.
