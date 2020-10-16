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
            row.value = UserSettings.mapType
            row.cell.segmentedControl.apportionsSegmentWidthsByContent = true
        }
        
        form +++ SwitchRow(tagFlatMarkers) {
            row in
            row.title = "Flat Markers".localised
            row.value = UserSettings.flatMarkers
        }
        
        <<< SegmentedRow<String>(tagLonglatStyle) {
            row in
            row.title = "Long. and Lat. Format".localised
            row.options = ["DMS", "DD"]
            row.value = UserSettings.longLatStyle
        }
        
        <<< SwitchRow(tagShowGraticules) {
            row in
            row.title = "Show Graticules".localised
            row.value = UserSettings.showGraticules
        }
    }
    
    @IBAction func doneTapped() {
        let values = form.values()
        guard let mapType = values[tagMapType] as? MapType else {
            return
        }
        guard let flatMarkers = values[tagFlatMarkers] as? Bool else {
            return
        }
        guard let longLatStyle = values[tagLonglatStyle] as? String else {
            return
        }
        guard let showGraticules = values[tagShowGraticules] as? Bool else {
            return
        }
        UserSettings.mapType = mapType
        UserSettings.flatMarkers = flatMarkers
        UserSettings.longLatStyle = longLatStyle
        UserSettings.showGraticules = showGraticules
        performSegue(withIdentifier: "unwindToMap", sender: nil)
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
