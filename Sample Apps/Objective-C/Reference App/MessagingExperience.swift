//
//  MessagingExperience.swift
//  CAO-LPMessagingSDKMaker
//
//  Created by Aaron Bratcher on 11/20/17.
//  Copyright © 2017 Liveperson. All rights reserved.
//

import Foundation
import ContactAtOnceMessaging
import UserNotifications
import UIKit

let messagingNotificationReceived = "messagingNotificationReceived"

// here to prevent a protocol definition error in the generated -Swift.h
@objc protocol MessagingDelegate { }

@objcMembers
class MessagingExperience: NSObject {
	static let shared = MessagingExperience()
	let messagingVersion = Messaging.sdkVersion

	private var messaging: Messaging?
	private var notificationManager: MessagingNotificationManager?

	func initialize() -> Bool {
		messaging = nil
		let providerID = AppSettings.shared.providerID
		let applicationID = AppSettings.shared.applicationID

		guard let baseDomain = AppSettings.shared.baseURL
			, providerID > 0
			, applicationID > 0
			, !baseDomain.isEmpty
			else { return false }

		let consumerProperties = MessagingConsumerProperties(applicationID: applicationID, providerID: providerID, baseDomain: baseDomain)

		if let messaging = Messaging(consumerProperties: consumerProperties, delegate: self) {
			self.messaging = messaging
			notificationManager = MessagingNotificationManager(messaging: messaging)
			UNUserNotificationCenter.current().delegate = notificationManager
			customizeMessaging()
			return true
		} else {
			print("ERROR initializing Messaging")
		}

		return false
	}

	func registerForPushNotifications(with deviceToken: Data) {
		if let notificationManager = notificationManager {
			notificationManager.registerForPushNotifications(with: deviceToken)
		}
	}

	func reset() {
		guard let messaging = messaging else { return }
		messaging.reset(completion: {
			print("log out complete")
		}) { (error) in
			print("Logout error: \(error.localizedDescription)")
		}
	}

	func showConversation(for referenceID: String, name: String, with initialUserText: String?, in viewController: UIViewController?) {
		guard let messaging = messaging else { return }
		messaging.showConversation(for: referenceID, name: name, with: initialUserText, in: viewController)
	}

	func showAllConversations() {
		guard let messaging = messaging else { return }
		messaging.showAllConversations()
	}

	private func customizeMessaging() {
		MessagingConfig.shared.userBubbleBorderColor = UIColor.red
		MessagingConfig.shared.userBubbleBorderWidth = 1.5
		MessagingConfig.shared.userBubbleBackgroundColor = UIColor(hexColor: "#FFD1A6")
		MessagingConfig.shared.userBubbleTextColor = UIColor.black
		MessagingConfig.shared.unreadCountBadgeTextColor = UIColor.white
		MessagingConfig.shared.unreadCountBadgeBackgroundColor = UIColor.orange
		MessagingConfig.shared.allConversationsTitle = "Dealer Messages"
		MessagingConfig.shared.conversationNavigationBackgroundColor = UIColor.orange
		MessagingConfig.shared.conversationNavigationTitleColor = UIColor.white
	}
}

extension MessagingExperience: ContactAtOnceMessaging.MessagingDelegate {
	func MessagingObseleteVersion(_ error: NSError) {
		guard let errorCode = MessagingErrorCode(rawValue: error.code) else { return }

		switch errorCode {
		case .unsupportedOSVersion:
			print("unsupported OS version")

		case .unsupportedSDKVersion:
			print("unsupported SDK version")

		default:
			break
		}
	}

	func MessagingError(_ error: NSError) {
		print(error.localizedDescription)
	}
}

private class MessagingNotificationManager: NSObject {
	let messaging: Messaging

	init(messaging: Messaging) {
		self.messaging = messaging
		super.init()
		messaging.notificationDelegate = self
	}

	func registerForPushNotifications(with deviceToken: Data) {
		messaging.registerForPushNotifications(with: deviceToken)
	}
}

extension MessagingNotificationManager: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

		var options: UNNotificationPresentationOptions = [.alert, .badge, .sound]
		if messaging.isShowingConversation(for: notification) {
			options = []
		}

		completionHandler(options)
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

		messaging.handleNotification(response.notification)
		completionHandler()
	}
}

extension MessagingNotificationManager: MessagingNotificationDelegate {
	func shouldShowMessagingNotification(notification: MessagingNotification) -> Bool {
		return false
	}

	func didReceiveMessagingNotification(_ notification: MessagingNotification) {
		if let listing = ListingsManager.shared.listings().filter({ $0.referenceID == notification.referenceID }).first {
			// give time for listings controller to load when launching app
			delay(0.1, closure: {
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: messagingNotificationReceived), object: listing)
			})
		}
	}
}

func delay(_ seconds: Double, closure: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

