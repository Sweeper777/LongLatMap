import UIKit

class DMSLongLatInputView : UIView {
    var degreeTextField: DMSLongLatTextField!
    var minuteTextField: DMSLongLatTextField!
    var secondTextField: DMSLongLatTextField!
    var signSelector: UISegmentedControl!
    
    let fontSize = 22.f
    
    enum Mode {
        case longitude
        case latitude
    }
    
    var mode = Mode.latitude {
        didSet {
            switch mode {
            case .longitude:
                signSelector.setTitle("E", forSegmentAt: 0)
                signSelector.setTitle("W", forSegmentAt: 1)
                degreeTextField.placeholder = "000"
                degreeTextField.validRange = 0..<180
            case .latitude:
                signSelector.setTitle("N", forSegmentAt: 0)
                signSelector.setTitle("S", forSegmentAt: 1)
                degreeTextField.placeholder = "00"
                degreeTextField.validRange = 0..<90
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
        degreeTextField = DMSLongLatTextField()
        minuteTextField = DMSLongLatTextField()
        secondTextField = DMSLongLatTextField()
        signSelector = UISegmentedControl(items: ["N", "S"])
        signSelector.selectedSegmentIndex = 0
        signSelector.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: fontSize)], for: .normal)
        [degreeTextField, minuteTextField, secondTextField].forEach { (tf) in
            tf?.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
        }
        let degreeLabel = UILabel()
        degreeLabel.text = "°"
        let minuteLabel = UILabel()
        minuteLabel.text = "\""
        let secondLabel = UILabel()
        secondLabel.text = "'"
        [degreeLabel, minuteLabel, secondLabel].forEach {
            l in l.font = UIFont.systemFont(ofSize: fontSize)
        }
        let stackView = UIStackView(arrangedSubviews:
            [degreeTextField,
             degreeLabel,
             minuteTextField,
             minuteLabel,
             secondTextField,
             secondLabel,
             signSelector
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
}

class DMSLongLatTextField: UITextField, UITextFieldDelegate {
    let padding = 10.f
    var validRange = 0..<90

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
        placeholder = "00"
        borderStyle = .none
        autocorrectionType = .no
        keyboardType = .numberPad
        layer.cornerRadius = 10
        textAlignment = .right
        delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText == "" {
            return true
        }
        if let int = Int(updatedText) {
            return validRange.contains(int)
        } else {
            return false
        }
    }
}
