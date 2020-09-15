import UIKit
import Eureka

class MarkerEditorViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ LongLatRow(tagLatitude) {
            row in
            row.title = "Latitude".localised
        }
    }
    
    @IBAction func doneTapped() {
        
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
