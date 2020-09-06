import UIKit

class LongLatInputView : UIView {
    var modeSelector: UISegmentedControl!
    var okButton: UIButton!
    var dmsInput: DMSLongLatInputView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
}
