import UIKit

class DecimalLongLatInputView: UIView {
    private var degreesTextField: DecimalLongLatTextField!
    let fontSize = 22.f
    
    var mode = LongLatInputView.Mode.latitude {
        didSet {
            switch mode {
            case .longitude:
                degreesTextField.validRange = -180..<180
            case .latitude:
                degreesTextField.validRange = -90..<90
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        degreesTextField = DecimalLongLatTextField()
        degreesTextField.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
        degreesTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(degreesTextField)
        degreesTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        degreesTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        degreesTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}

fileprivate class DecimalLongLatTextField: UITextField, UITextFieldDelegate {
    let padding = 10.f
    var validRange: Range<Double> = -90..<90
    var number: Int? {
        text.flatMap(Int.init)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .tertiarySystemFill
        placeholder = "0"
        borderStyle = .none
        autocorrectionType = .no
        keyboardType = .decimalPad
        layer.cornerRadius = 10
        delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText == "" {
            return true
        }
        
        if updatedText == "-" {
            return true
        }
        
        if let double = Double(updatedText),
            validRange.contains(double) {
            return true
        } else {
            return false
        }
    }
}
