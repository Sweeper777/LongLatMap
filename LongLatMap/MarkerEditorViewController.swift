import UIKit
import Eureka

class MarkerEditorViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Location".localised)
        <<< LongLatRow(tagLatitude) {
            row in
            row.title = "Latitude".localised
            row.value = 0
        }
        <<< LongLatRow(tagLongitude) {
            row in
            row.title = "Longitude".localised
            row.mode = .longitude
            row.value = 0
        }.onPresent({ (form, presented) in
            if let longLatInputVC = presented as? LongLatInputController {
                longLatInputVC.mode = .longitude
            }
        })
    }
    
    @IBAction func doneTapped() {
        
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
