import UIKit
import CoreLocation

class DMSLongLatInputView : UIView {
    private var degreeTextField: DMSLongLatTextField!
    private var minuteTextField: DMSLongLatTextField!
    private var secondTextField: DMSLongLatTextField!
    var signSelector: UISegmentedControl!
    
    let fontSize = 22.f
    
    var mode = LongLatInputView.Mode.latitude {
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
    
    var degrees: CLLocationDegrees? {
        get {
            if let degree = degreeTextField.number,
                let minute = minuteTextField.number,
                let second = secondTextField.number {
                return dmsToDecimal(degrees: degree, minutes: minute, seconds: second, positive: signSelector.selectedSegmentIndex == 0)
            }
            return nil
        }
        
        set {
            if let value = newValue {
                let dms = decimalToDMS(decimalDegrees: value)
                degreeTextField.number = dms.degrees
                minuteTextField.number = dms.minutes
                secondTextField.number = dms.seconds
                signSelector.selectedSegmentIndex = dms.positive ? 0 : 1
            } else {
                degreeTextField.text = ""
                minuteTextField.text = ""
                secondTextField.text = ""
                signSelector.selectedSegmentIndex = 0
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
        degreeTextField.tag = 1
        minuteTextField = DMSLongLatTextField()
        minuteTextField.validRange = 0..<60
        minuteTextField.tag = 2
        secondTextField = DMSLongLatTextField()
        secondTextField.validRange = 0..<60
        secondTextField.tag = 3
        signSelector = UISegmentedControl(items: ["N", "S"])
        signSelector.selectedSegmentIndex = 0
        signSelector.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: fontSize)], for: .normal)
        [degreeTextField, minuteTextField, secondTextField].forEach { (tf) in
            tf?.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
            
        }
        let degreeLabel = UILabel()
        degreeLabel.text = "°"
        let minuteLabel = UILabel()
        minuteLabel.text = "′"
        let secondLabel = UILabel()
        secondLabel.text = "″"
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
    
    override func becomeFirstResponder() -> Bool {
        ([degreeTextField, minuteTextField, secondTextField]
            .first(where: { $0?.text?.isEmpty ?? false }) ?? secondTextField)?
            .becomeFirstResponder() ?? false
    }
    
    override var isFirstResponder: Bool {
        [degreeTextField, minuteTextField, secondTextField]
            .first(where: { $0?.isFirstResponder ?? false }) != nil
    }
}

fileprivate class DMSLongLatTextField: UITextField, UITextFieldDelegate {
    let padding = 10.f
    var validRange = 0..<90
    var number: Int? {
        get { text == "" ? 0 : text.flatMap(Int.init) }
        set {
            if newValue == nil || newValue == 0 {
                text = ""
            } else {
                text = "\(newValue!)"
            }
        }
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
            let previousResponderTag = self.tag - 1
            if let previousResponder = self.superview?.viewWithTag(previousResponderTag) {
                DispatchQueue.main.async {
                    previousResponder.becomeFirstResponder()
                }
            }
            return true
        }
        if let int = Int(updatedText) {
            let should = validRange.contains(int)
            
            let maximumDigits = Int(log10(Double(validRange.upperBound - 1))) + 1
            if should && string != "" && updatedText.count == maximumDigits {
                text = updatedText
                let nextResponderTag = self.tag + 1
                if let nextResponder = self.superview?.viewWithTag(nextResponderTag) {
                    nextResponder.becomeFirstResponder()
                } else {
                    self.resignFirstResponder()
                }
            }
            
            return should
        } else {
            return false
        }
    }
}
