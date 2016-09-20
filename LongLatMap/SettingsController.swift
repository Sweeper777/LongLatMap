import UIKit
import Eureka

class SettingsController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section(NSLocalizedString("Map Type", comment: ""))
            <<< SegmentedRow<MapType>(tagMapType) {
                row in
                row.options = [.Normal, .Satellite, .Hybrid, .Terrain]
                row.value = MapType(rawValue: UserDefaults.standard.string(forKey: tagMapType) ?? "Normal")!
        }.onChange {
            row in
            UserDefaults.standard.set(row.value!.rawValue, forKey: tagMapType)
        }
    }

    @IBAction func close(_ sender: AnyObject) {
        dismissVC(completion: nil)
    }
}
