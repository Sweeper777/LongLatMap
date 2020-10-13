import UIKit
import Eureka

class SettingsViewController : FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings".localised
        form +++ Section("Map Type".localised)
        <<< SegmentedRow<MapType>(tagMapType) {
            row in
            row.options = [.normal, .satellite, .hybrid, .terrain]
            row.value = MapType(rawValue: UserDefaults.standard.string(forKey: tagMapType) ?? "Normal")!
            row.cell.segmentedControl.apportionsSegmentWidthsByContent = true
        }
        
        form +++ SwitchRow(tagFlatMarkers) {
            row in
            row.title = "Flat Markers".localised
            row.value = UserDefaults.standard.bool(forKey: tagFlatMarkers)
        }
        
        <<< SegmentedRow<String>(tagLonglatStyle) {
            row in
            row.title = "Long. and Lat. Format".localised
            row.options = ["DMS", "DD"]
            row.value = UserDefaults.standard.string(forKey: tagLonglatStyle) ?? "DMS"
        }
        
    }
    
    @IBAction func doneTapped() {
        performSegue(withIdentifier: "unwindToMap", sender: nil)
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
