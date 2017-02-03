import UIKit
import Eureka

class MarkerInfoController: FormViewController {
    var marker: Marker?
    weak var delegate: MarkerInfoControllerDelegate?
    @IBOutlet var deleteBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 300, height: 400)
        
        if marker == nil {
            title = NSLocalizedString("New Marker", comment: "")
            self.navigationItem.rightBarButtonItems?.removeObject(deleteBtn)
        } else if marker!.title == nil || marker!.title == "" {
            title = NSLocalizedString("Unnamed Marker", comment: "")
        } else {
            title = marker!.title
        }
        
        form +++ Section(NSLocalizedString("location", comment: ""))
            <<< LongitudeSelectorRow(tag: tagLongitude) {
                row in
                row.title = NSLocalizedString("Longitude", comment: "")
                row.value = marker?.longitude?.doubleValue ?? 0
        }
            <<< LatitudeSelectorRow(tag: tagLatitude) {
                row in
                row.title = NSLocalizedString("Latitude", comment: "")
                row.value = marker?.latitude?.doubleValue ?? 0
        }
            +++ PickerInlineRow<Color>(tagColor) {
                row in
                row.title = NSLocalizedString("Color", comment: "")
                let options: [Color] = [.red, .orange, .yellow, .blue, .green, .purple, .cyan, .gray]
                row.options = options
                row.value = Color(rawValue: marker?.color ?? "Red")
        }
            <<< SliderRow(tagRotation) {
                row in
                row.title = NSLocalizedString("Rotation (°)", comment: "")
                row.minimumValue = -180
                row.maximumValue = 180
                row.value = marker?.rotation?.floatValue ?? 0.0
                row.steps = 360
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
    }
    
    @IBAction func close(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        delegate?.controllerDismissed(self)
    }
    
    @IBAction func deleteMarker(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        delegate?.markerDeleted(self)
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
