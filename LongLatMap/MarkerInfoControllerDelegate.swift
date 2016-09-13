import UIKit

protocol MarkerInfoControllerDelegate {
    func controllerDismissed(markerInfoController: MarkerInfoController, values: [String: Any])
}