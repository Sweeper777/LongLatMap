import UIKit

class DMSLongLatInputView : UIView {
    var degreeTextField: LongLatTextField!
    var minuteTextField: LongLatTextField!
    var secondTextField: LongLatTextField!
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
            case .latitude:
                signSelector.setTitle("N", forSegmentAt: 0)
                signSelector.setTitle("S", forSegmentAt: 1)
                degreeTextField.placeholder = "00"
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
        degreeTextField = LongLatTextField()
        minuteTextField = LongLatTextField()
        secondTextField = LongLatTextField()
        signSelector = UISegmentedControl(items: ["N", "S"])
        signSelector.selectedSegmentIndex = 0
        signSelector.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: fontSize)], for: .normal)
        [degreeTextField, minuteTextField, secondTextField].forEach { (tf) in
            tf?.backgroundColor = .tertiarySystemFill
            tf?.placeholder = "00"
            tf?.borderStyle = .none
            tf?.autocorrectionType = .no
            tf?.keyboardType = .numberPad
            tf?.layer.cornerRadius = 10
            tf?.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
            tf?.textAlignment = .right
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

class LongLatTextField: UITextField {
    let padding = 10.f

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
