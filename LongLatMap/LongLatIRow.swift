import UIKit
import Eureka
import CoreLocation

final class LongLatRow: SelectorRow<LongLatCell>, RowType {
    var mode: LongLatInputView.Mode = .latitude
    let longLatFormatter = LongLatFormatter()
    
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
            self.longLatFormatter.mode = self.mode
            return self.longLatFormatter.string(for: degrees)
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
