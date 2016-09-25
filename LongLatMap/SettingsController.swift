import UIKit
import Eureka

class SettingsController: FormViewController {
    weak var delegate: SettingsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Settings", comment: "")
        form +++ Section(NSLocalizedString("Map Type", comment: ""))
            <<< SegmentedRow<MapType>(tagMapType) {
                row in
                row.options = [.Normal, .Satellite, .Hybrid, .Terrain]
                row.value = MapType(rawValue: UserDefaults.standard.string(forKey: tagMapType) ?? "Normal")!
                row.cell.segmentedControl.apportionsSegmentWidthsByContent = true
        }.onChange {
            [weak self] row in
            UserDefaults.standard.set(row.value!.rawValue, forKey: tagMapType)
            self?.delegate?.settingsController(self!, mapTypeChangedTo: row.value!.rawValue)
        }
        
        form +++ SwitchRow(tagFlatMarkers) {
                row in
                row.title = NSLocalizedString("Flat Markers", comment: "")
                row.value = UserDefaults.standard.bool(forKey: tagFlatMarkers)
        }.onChange {
            row in
            UserDefaults.standard.set(row.value!, forKey: tagFlatMarkers)
            self.delegate?.settingsController(self, flatMarkerChangedTo: row.value!)
        }
    }

    @IBAction func close(_ sender: AnyObject) {
        dismissVC(completion: nil)
    }
}
