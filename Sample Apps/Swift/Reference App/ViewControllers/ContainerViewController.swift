//
//  ConsumerSettingsController.swift
//  CAO Test
//
//  Created by Aaron L. Bratcher on 11/14/17.
//  Copyright © 2017 Liveperson. All rights reserved.
//


import UIKit

class ContainerViewController: UIViewController {
	var referenceID = ""
	var initialUserText: String? = nil

	override func viewDidLoad() {
		MessagingExperience.shared.showConversation(for: referenceID, name: title ?? "", with: initialUserText, in: self)
	}
}

