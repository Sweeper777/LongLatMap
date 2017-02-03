import UIKit
import Eureka
import CoreLocation

class LongitudeSelectorController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, TypedRowControllerType {

    /// A closure to be called when the controller disappears.
    public var onDismissCallback: ((UIViewController) -> ())?
    
    @IBOutlet var longitudePicker: UIPickerView!
    var row: RowOf<CLLocationDegrees>!
    var completionCallback: ((UIViewController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let longitude = row?.value {
            let (degrees, minutes, seconds) = decimalToDMS(longitude)
            
            longitudePicker.selectRow(abs(degrees), inComponent: 0, animated: false)
            longitudePicker.selectRow(minutes, inComponent: 1, animated: false)
            longitudePicker.selectRow(seconds, inComponent: 2, animated: false)
            longitudePicker.selectRow(degrees < 0 ? 1 : 0, inComponent: 3, animated: false)
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 180
        case 1, 2:
            return 60
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var suffix = ""
        
        switch component {
        case 0:
            suffix = "°"
        case 1:
            suffix = "'"
        case 2:
            suffix = "\""
        default:
            suffix = ""
        }
        
        if component == 3 {
            if row == 0 {
                return "E"
            } else {
                return "W"
            }
        }
        
        return String(row) + suffix
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let degrees = longitudePicker.selectedRow(inComponent: 0)
        let minutes = longitudePicker.selectedRow(inComponent: 1)
        let seconds = longitudePicker.selectedRow(inComponent: 2)
        let negative = longitudePicker.selectedRow(inComponent: 3) == 1
        self.row?.value = (Double(degrees) + Double(minutes) / 60.0 + Double(seconds) / 3600.0) * (negative ? -1 : 1)
    }

}
