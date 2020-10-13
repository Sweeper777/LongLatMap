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
        
    }
    
    @IBAction func doneTapped() {
        performSegue(withIdentifier: "unwindToMap", sender: nil)
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}