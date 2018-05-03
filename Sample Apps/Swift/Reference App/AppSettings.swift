//
//  AppSettings.swift
//  CAO Test
//
//  Created by Aaron L. Bratcher on 11/27/2017.
//  Copyright © 2017 Live Person. All rights reserved.
//

import Foundation

let useFullScreenKey = "UseFullScreen"
let providerIDKey = "ProviderIDKey"
let applicationIDKey = "ApplicationIDKey"
let baseURLKey = "BaseURLKey"

class AppSettings {
	static let shared = AppSettings()

	var hasCredentials: Bool {
		if providerID == nil
			|| applicationID == nil
			|| baseURL == nil {
			return false
		}

		return true
	}

	private let defaults = UserDefaults.standard

	var useFullScreen: Bool = false { didSet { defaults.set(useFullScreen, forKey: useFullScreenKey) } }
	var providerID: Int? { didSet { defaults.set(providerID, forKey: providerIDKey) } }
	var applicationID: Int? { didSet { defaults.set(applicationID, forKey: applicationIDKey) } }
	var baseURL: String? { didSet { defaults.set(baseURL, forKey: baseURLKey) } }

	private init() {
		useFullScreen = defaults.bool(forKey: useFullScreenKey)
		providerID = defaults.integer(forKey: providerIDKey)
		applicationID = defaults.integer(forKey: applicationIDKey)
		baseURL = defaults.string(forKey: baseURLKey)
	}
}
