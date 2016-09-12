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
        
        form +++ Section(NSLocalizedString("location", comment: ""))
            <<< DecimalRow(tagLongitude) {
                row in
                row.title = NSLocalizedString("Longitude", comment: "")
                row.value = marker?.longitude?.doubleValue ?? 0
        }
            <<< DecimalRow(tagLatitude) {
                row in
                row.title = NSLocalizedString("Latitude", comment: "")
                row.value = marker?.latitude?.doubleValue ?? 0
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissVC(completion: nil)
    }
}
