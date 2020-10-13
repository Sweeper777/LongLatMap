import UIKit
import Eureka

class SettingsViewController : FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings".localised
    }
    
    @IBAction func doneTapped() {
        performSegue(withIdentifier: "unwindToMap", sender: nil)
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
