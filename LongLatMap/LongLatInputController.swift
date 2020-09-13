import UIKit
import Eureka

class LongLatInputController: SelectorViewController<SelectorRow<LongLatCell>> {
    
    @IBOutlet var longLatInputView: LongLatInputView!
    
    override func viewDidLoad() {
        longLatInputView.degrees = row.value
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onDismissCallback!(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}
