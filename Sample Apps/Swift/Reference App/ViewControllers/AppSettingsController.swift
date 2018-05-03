//
//  AppSettingsController.swift
//  CAO Test
//
//  Created by Aaron L. Bratcher on 11/14/17.
//  Copyright © 2017 Liveperson. All rights reserved.
//

import Foundation
import UIKit

class AppSettingsController: UITableViewController {
	@IBOutlet weak var applicationID: UITextField!
	@IBOutlet weak var providerID: UITextField!
	@IBOutlet weak var baseURL: UITextField!
	@IBOutlet weak var useFullScreenSwitch: UISwitch!
	@IBOutlet weak var frameworkVersionLabel: UILabel!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let applicationID = AppSettings.shared.applicationID, applicationID != 0 {
			self.applicationID.text = "\(applicationID)"
		}

		if let providerID = AppSettings.shared.providerID, providerID != 0 {
			self.providerID.text = "\(providerID)"
		}
		baseURL.text = AppSettings.shared.baseURL
		useFullScreenSwitch.setOn(AppSettings.shared.useFullScreen, animated: false)
		frameworkVersionLabel.text = MessagingExperience.shared.messagingVersion
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if let applicationID = applicationID.text, !applicationID.isEmpty {
			AppSettings.shared.applicationID = Int(applicationID)
		} else {
			if let placeholderText = applicationID.placeholder {
				AppSettings.shared.applicationID = Int(placeholderText)
			} else {
				AppSettings.shared.applicationID = nil
			}
		}

		if let providerID = providerID.text, !providerID.isEmpty {
			AppSettings.shared.providerID = Int(providerID)
		} else {
			if let placeholderText = providerID.placeholder {
				AppSettings.shared.providerID = Int(placeholderText)
			} else {
				AppSettings.shared.providerID = nil
			}
		}

		if let baseURLText = baseURL.text, !baseURLText.isEmpty {
			AppSettings.shared.baseURL = baseURLText
		} else {
			if let placeholderText = baseURL.placeholder {
				AppSettings.shared.baseURL = placeholderText
			} else {
				AppSettings.shared.baseURL = nil
			}
		}

		let _ = MessagingExperience.shared.initialize()
	}

	@IBAction func useFullScreenSwitchFlipped(_ sender: UISwitch) {
		AppSettings.shared.useFullScreen = sender.isOn
	}

	@IBAction func resetDataTapped(_ sender: UIButton) {
		let errorAlert = UIAlertController(title: "Reset Data", message: "Resetting data will remove all Liveperson conversations and credentials from this application.", preferredStyle: UIAlertControllerStyle.alert)

		errorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
		{ action -> Void in
			// do nothing
		})

		errorAlert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.destructive) { [weak self] action -> Void in
			guard let `self` = self else { return }

			DispatchQueue.main.async {
				MessagingExperience.shared.reset()
				UserDefaults.standard.removeObject(forKey: referenceDefaultsKey)
				self.applicationID.placeholder = self.applicationID.text
				self.providerID.placeholder = self.providerID.text
				self.baseURL.placeholder = self.baseURL.text
				self.applicationID.text = nil
				self.providerID.text = nil
				self.baseURL.text = nil
			}
		})

		self.present(errorAlert, animated: true, completion: nil)
	}
}
