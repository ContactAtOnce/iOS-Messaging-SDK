//
//  ListingsViewController.swift
//  CAO Test
//
//  Created by Aaron L. Bratcher on 11/27/2017.
//  Copyright © 2017 Live Person. All rights reserved.
//

import UIKit

class ListingsViewController: UITableViewController, Segues {
	var listings: [Listing] = []
	var isVisible = false

	enum SegueIdentifier: String {
		case showSettings
		case showChatContainer
	}

	override func viewDidLoad() {
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: messagingNotificationReceived), object: nil, queue: nil) { [weak self] (notification) in
			if let listing = notification.object as? Listing {
				self?.chat(with: listing)
			}
		}

		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: listingUpdated), object: nil, queue: nil) { [weak self](notification) in
			if let listing = notification.object as? Listing {
				self?.listings.append(listing)
				self?.tableView.reloadData()
			}
		}

		navigationController?.navigationBar.barTintColor = UIColor.orange
		navigationController?.navigationBar.tintColor = UIColor.white
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		navigationController?.navigationBar.backItem?.titleView?.tintColor = UIColor.white
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		listings = ListingManager.shared.listings()
		tableView.reloadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		if !AppSettings.shared.hasCredentials {
			delay(1, closure: {
				self.performSegueWithIdentifier(.showSettings, sender: nil)
			})
		}
		isVisible = true
	}

	override func viewDidDisappear(_ animated: Bool) {
		isVisible = false
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let identifier = identifierForSegue(segue)

		if identifier == .showChatContainer
			, let chatInfo = sender as? [String: String]
			, let referenceID = chatInfo[ListingPart.referenceID]
			, let title = chatInfo[ListingPart.name]
			, let container = segue.destination as? ContainerViewController {

			if let initialUserText = chatInfo[ListingPart.initialUserText] as? String {
				container.initialUserText = initialUserText
			}

			container.referenceID = referenceID
			container.title = title
		}
	}

	private func delay(_ seconds: Double, closure: @escaping () -> Void) {
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
	}
}

extension ListingsViewController {
	@IBAction func showSettingsTapped(_ sender: Any) {
		performSegueWithIdentifier(.showSettings, sender: nil)
	}

	@IBAction func showAllTapped(_ sender: Any) {
		MessagingExperience.shared.showAllConversations()
	}

	@IBAction func addTapped(_ sender: UIBarButtonItem) {
		manageListing(nil)
	}

	private func manageListing(_ listing: Listing? = nil, at indexPath: IndexPath? = nil) {
		let errorAlert = UIAlertController(title: "Add Listing", message: nil, preferredStyle: UIAlertControllerStyle.alert)
		let newListing = listing == nil

		errorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel)
		{ action -> Void in
			// do nothing
		})

		errorAlert.addAction(UIAlertAction(title: "Add", style: .default)
		{ action -> Void in
			guard let textFields = errorAlert.textFields
				, let name = textFields[0].text
				, let referenceID = textFields[1].text
				, !name.isEmpty && !referenceID.isEmpty
				else { return }

			let initialUserText = textFields[2].text
			let listing = Listing(name: name, referenceID: referenceID, initialUserText: initialUserText)
			if !newListing, let indexPath = indexPath {
				ListingManager.shared.update(listing: listing, at: indexPath.row)
			} else {
				ListingManager.shared.add(listing: listing)
			}
		})

		errorAlert.addTextField(configurationHandler: { (textField) in
			textField.placeholder = "Name"
			textField.text = listing?.name
		})

		errorAlert.addTextField(configurationHandler: { (textField) in
			textField.placeholder = "ReferenceID"
			textField.text = listing?.referenceID
		})

		errorAlert.addTextField(configurationHandler: { (textField) in
			textField.placeholder = "Initial User Text"
			textField.text = listing?.initialUserText
		})

		self.present(errorAlert, animated: true, completion: nil)
	}
}

extension ListingsViewController: ReferenceTableCellDelegate {
	func chat(with listing: Listing, initialUserText: String? = nil) {
		if AppSettings.shared.useFullScreen {
			MessagingExperience.shared.showConversation(for: listing.referenceID, name: listing.name, with: initialUserText, in: nil)
		} else {
			if let _ = navigationController?.topViewController as? ContainerViewController {
				navigationController?.popViewController(animated: false)
			}

			let chatInfo = [ListingPart.referenceID: listing.referenceID, ListingPart.name: listing.name, ListingPart.initialUserText: initialUserText]
			performSegueWithIdentifier(.showChatContainer, sender: chatInfo as AnyObject)
		}
	}
}

extension ListingsViewController {
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
			self.manageListing(self.listings[indexPath.row], at: indexPath)
		}

		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
			ListingManager.shared.delete(at: indexPath.row)
		}

		return [edit, delete]
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listings.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as ListingCell
		let listing = listings[indexPath.row]
		cell.initialize(delegate: self)
		cell.show(listing: listing)

		return cell
	}
}

extension ListingsViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
