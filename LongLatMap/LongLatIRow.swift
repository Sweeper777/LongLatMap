import UIKit
import Eureka
import CoreLocation

final class LongLatRow: SelectorRow<LongLatCell>, RowType {
    var mode: LongLatInputView.Mode = .latitude
    
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .presentModally(controllerProvider: .storyBoard(storyboardId: "longLatInputController", storyboardName: "Main", bundle: Bundle.main),
                                           onDismiss: { (vc) in
                                            vc.dismiss(animated: true, completion: nil)
        })
        displayValueFor = {
            x in
            guard let degrees = x else {
                return ""
            }
            let dms = decimalToDMS(decimalDegrees: degrees)
            let direction: String
            if self.mode == .latitude {
                direction = dms.positive ? "N" : "S"
            } else {
                direction = dms.positive ? "E" : "W"
            }
            return "\(dms.degrees)°\(dms.minutes)′\(dms.seconds)″\(direction)"
        }
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        deselect(animated: true)
        updateCell()
    }
}

class LongLatCell: AlertSelectorCell<CLLocationDegrees> {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        contentView.backgroundColor = .systemGray3
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        contentView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        contentView.backgroundColor = .secondarySystemGroupedBackground
    }
}
