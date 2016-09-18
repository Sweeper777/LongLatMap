import UIKit

@objc protocol MarkerInfoControllerDelegate {
    func controllerDismissed(_ markerInfoController: MarkerInfoController)
    
    func markerDeleted(_ markerInfoController: MarkerInfoController)
}
