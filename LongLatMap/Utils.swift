import Foundation

extension String {
    var localised: String {
        NSLocalizedString(self, comment: "")
    }
}
