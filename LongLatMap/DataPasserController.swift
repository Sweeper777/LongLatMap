import UIKit

class DataPasserController: UINavigationController {
    var marker: Marker?
    weak var markerInfoDelegate: MarkerInfoControllerDelegate?
    weak var settingsDelegate: SettingsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = topViewController as? MarkerInfoController {
            vc.marker = self.marker
            vc.delegate = self.markerInfoDelegate
        } else if let vc = topViewController as? SettingsController {
            vc.delegate = settingsDelegate
        }
    }

}
