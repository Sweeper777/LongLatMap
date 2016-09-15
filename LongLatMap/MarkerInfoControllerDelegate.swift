import UIKit

@objc protocol MarkerInfoControllerDelegate {
    func controllerDismissed(markerInfoController: MarkerInfoController)
    
    func markerDeleted(markerInfoController: MarkerInfoController)
}