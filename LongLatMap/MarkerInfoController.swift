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
            let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(close))
            saveItem.tintColor = UIColor.white
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            cancelItem.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItems = [saveItem]
            self.navigationItem.leftBarButtonItems = [cancelItem]
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
                row.addRule(rule: RuleRequired())
        }
            <<< DecimalRow(tagLatitude) {
                row in
                row.title = NSLocalizedString("Latitude", comment: "")
                row.value = marker?.latitude?.doubleValue ?? 0
                row.addRule(rule: RuleRequired())
        }
            +++ PickerInlineRow<Color>(tagColor) {
                row in
                row.title = NSLocalizedString("Color", comment: "")
                let options: [Color] = [.Red, .Orange, .Yellow, .Blue, .Green, .Purple, .Cyan, .Gray]
                row.options = options
                row.value = Color(rawValue: marker?.color ?? "Red")
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
        let errors = form.validate()
        if errors.count == 0 {
            dismiss(animated: true, completion: nil)
            delegate?.controllerDismissed(self)
        } else if marker == nil {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You must fill in the latitude and longitude of the new marker!", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
            self.presentVC(alert)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteMarker(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        delegate?.markerDeleted(self)
    }
    
    func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let errors = form.validate()
        if marker != nil && errors.count == 0  {
            delegate?.controllerDismissed(self)
        }
    }
}
