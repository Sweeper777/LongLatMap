import UIKit
import Eureka
import CoreLocation

class LongLatInputController: SelectorViewController<SelectorRow<LongLatCell>> {
    
    @IBOutlet var longLatInputView: LongLatInputView!
    @IBOutlet var container: UIView!
    
    override func viewDidLoad() {
        container.layer.cornerRadius = 10
        
        longLatInputView.delegate = self
        longLatInputView.degrees = row.value
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.view)
            if !container.frame.contains(touchPoint) {
                onDismissCallback!(self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}

extension LongLatInputController : LongLatInputViewDelegate {
    func didSelectDegrees(_ degrees: CLLocationDegrees) {
        row.value = degrees
        row.updateCell()
        onDismissCallback!(self)
    }
}
