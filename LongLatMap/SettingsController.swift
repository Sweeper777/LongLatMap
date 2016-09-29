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
                row.options = [.normal, .satellite, .hybrid, .terrain]
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
        
            <<< PickerInlineRow<LongLatStyle>(tagLonglatStyle) {
                row in
                row.title = NSLocalizedString("Long. and Lat. Style", comment: "")
                row.options = [.integer, .sigFig1, .sigFig2, .sigFig3, .sigFig4, .sigFig5, .sigFig6, .sigFig7, .sigFig8, .sigFig9]
                row.value = LongLatStyle(rawValue: UserDefaults.standard.integer(forKey: tagLonglatStyle) - 1) ?? .sigFig5
        }.onChange {
            row in
            UserDefaults.standard.set(row.value!.rawValue + 1, forKey: tagLonglatStyle)
            self.delegate?.settingsController(self, longLatStyleChangedTo: row.value!.rawValue)
        }
    }

    @IBAction func close(_ sender: AnyObject) {
        dismissVC(completion: nil)
    }
}
