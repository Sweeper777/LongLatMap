import UIKit
import Eureka

class MarkerInfoController: FormViewController, UIPopoverPresentationControllerDelegate {
    var marker: Marker?
    weak var delegate: MarkerInfoControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.popoverPresentationController!.delegate = self
        
        if marker == nil {
            title = NSLocalizedString("New Marker", comment: "")
        } else if marker!.title == nil || marker!.title == "" {
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
            +++ TextRow(tagTitle) {
                row in
                row.title = NSLocalizedString("Title", comment: "")
                row.value = marker?.title ?? ""
        }
            +++ Section(NSLocalizedString("description", comment: ""))
            
            <<< TextAreaRow(tagDescription) {
                row in
                row.value = marker?.desc ?? ""
        }
        
            +++ PickerInlineRow<Color>(tagColor) {
                row in
                row.title = NSLocalizedString("Color", comment: "")
                let options: [Color] = [.Red, .Orange, .Yellow, .Blue, .Green, .Purple, .Cyan, .Gray]
                row.options = options
                row.value = Color(rawValue: marker?.color ?? "Red")
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissVC(completion: nil)
        delegate?.controllerDismissed(self)
    }
    
    @IBAction func deleteMarker(sender: AnyObject) {
        dismissVC(completion: nil)
        delegate?.markerDeleted(self)
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        delegate?.controllerDismissed(self)
    }
}
