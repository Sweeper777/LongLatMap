import UIKit

class DataPasserController: UINavigationController {
    var marker: Marker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = topViewController as? MarkerInfoController {
            vc.marker = self.marker
        }
    }

}
