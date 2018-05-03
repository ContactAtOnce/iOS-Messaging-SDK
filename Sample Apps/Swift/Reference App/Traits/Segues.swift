import Foundation
import UIKit

protocol Segues {
	associatedtype SegueIdentifier: RawRepresentable
}

extension Segues where Self: UIViewController, SegueIdentifier.RawValue == String {
	func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
		performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
	}

	func identifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
		guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else { fatalError("Invalid segue identifier \(String(describing: segue.identifier)).") }

		return segueIdentifier
	}
}
