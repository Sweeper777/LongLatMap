import UIKit
import Eureka

class MarkerInfoController: FormViewController {
    var marker: Marker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if marker == nil {
            title = NSLocalizedString("New Marker", comment: "")
        } else if marker!.title == nil {
            title = NSLocalizedString("Unnamed Marker", comment: "")
        } else {
            title = marker!.title
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissVC(completion: nil)
    }
}
