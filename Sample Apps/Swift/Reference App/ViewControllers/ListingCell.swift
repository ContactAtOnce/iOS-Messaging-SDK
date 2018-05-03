//
//  ReferenceCell.swift
//  CAO Test
//
//  Created by Aaron Bratcher on 11/27/17.
//  Copyright © 2017 Liveperson. All rights reserved.
//

import Foundation
import UIKit

protocol ReferenceTableCellDelegate {
	func chat(with listing: Listing, initialUserText: String?)
}

class ListingCell: UITableViewCell, Reusable {
	@IBOutlet weak var name: UILabel!

	var delegate: ReferenceTableCellDelegate?
	var listing: Listing?

	override func prepareForReuse() {
		self.listing = nil
		name.text = nil
	}

	func initialize(delegate: ReferenceTableCellDelegate) {
		self.delegate = delegate
	}

	func show(listing: Listing) {
		self.listing = listing
		name.text = listing.name
	}

	@IBAction func chatButtonTapped(_ sender: UIButton) {
		guard let listing = listing else { return }

		delegate?.chat(with: listing, initialUserText: listing.initialUserText)
	}
}
