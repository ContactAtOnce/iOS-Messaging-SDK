//
//  ListingsManager.swift
//  CAO Test
//
//  Created by Aaron Bratcher on 12/8/17.
//  Copyright © 2017 Liveperson. All rights reserved.
//

import Foundation

let referenceDefaultsKey = "ReferenceDefaultsKey"
typealias Listing = (name: String, referenceID: String, initialUserText: String?)

enum ListingPart {
	static let name = "name"
	static let referenceID = "referenceID"
	static let initialUserText = "initialUserText"
}

let listingUpdated = "listingUpdated"

class ListingManager {
	static let shared = ListingManager()

	private init() {  }

	func listings() -> [Listing] {
		var listings: [Listing] = []
		if let savedReferences = UserDefaults.standard.array(forKey: referenceDefaultsKey) as? [[String: String]] {
			for reference in savedReferences {
				guard let name = reference[ListingPart.name]
					, let referenceID = reference[ListingPart.referenceID]
					else { continue }

				let initialUserText = reference[ListingPart.initialUserText]
				let listing = Listing(name: name, referenceID: referenceID, initialUserText: initialUserText)
				listings.append(listing)
			}
		}

		return listings
	}

	func add(listing: Listing) {
		var references: [[String: String?]] = []
		let listingDict = [ListingPart.name: listing.name
			, ListingPart.referenceID: listing.referenceID
			, ListingPart.initialUserText: listing.initialUserText
		]

		if let savedReferences = UserDefaults.standard.array(forKey: referenceDefaultsKey) as? [[String: String?]] {
			references = savedReferences
		}

		references.append(listingDict)
		UserDefaults.standard.set(references, forKey: referenceDefaultsKey)
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: listingUpdated), object: nil)
	}

	func update(listing: Listing, at index: Int) {
		guard var references = UserDefaults.standard.array(forKey: referenceDefaultsKey) as? [[String: String?]] else { return }

		let listingDict = [ListingPart.name: listing.name
			, ListingPart.referenceID: listing.referenceID
			, ListingPart.initialUserText: listing.initialUserText
		]

		references[index] = listingDict
		UserDefaults.standard.set(references, forKey: referenceDefaultsKey)
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: listingUpdated), object: nil)
	}

	func delete(at index: Int) {
		guard var references = UserDefaults.standard.array(forKey: referenceDefaultsKey) as? [[String: String?]] else { return }
		references.remove(at: index)
		UserDefaults.standard.set(references, forKey: referenceDefaultsKey)
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: listingUpdated), object: nil)
	}
}
