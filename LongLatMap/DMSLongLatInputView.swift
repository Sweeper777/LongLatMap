import UIKit

class DMSLongLatInputView : UIView {
    var degreeTextField: UITextField!
    var minuteTextField: UITextField!
    var secondTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
}

