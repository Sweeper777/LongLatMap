import UIKit
import CoreLocation

class DecimalLongLatInputView: UIView {
    private var degreesTextField: DecimalLongLatTextField!
    private var signToggler: UIButton!
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
    
    var degrees: CLLocationDegrees? {
        degreesTextField.text.flatMap(Double.init)
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
        
        signToggler = UIButton(type: .system)
        signToggler.setImage(UIImage(systemName: "plus.slash.minus"), for: .normal)
        signToggler.addTarget(self, action: #selector(toggleSign), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [
            degreesTextField,
            signToggler
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func toggleSign() {
        if degreesTextField.text.isNilOrEmpty {
            degreesTextField.text = "-"
            return
        }
        if degreesTextField.text == "-" {
            degreesTextField.text = ""
            return
        }
        if let double = Double(degreesTextField.text!) {
            if double > 0 && !degreesTextField.text!.hasPrefix("-") {
                degreesTextField.text = "-" + degreesTextField.text!
            } else if double < 0 && degreesTextField.text!.hasPrefix("-") {
                degreesTextField.text = String(degreesTextField.text!.dropFirst())
            }
        }
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
        if Locale.current.decimalSeparator == "." {
            keyboardType = .decimalPad
        } else {
            keyboardType = .numbersAndPunctuation
        }
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
