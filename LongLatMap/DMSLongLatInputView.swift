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
        degreeTextField = UITextField()
        minuteTextField = UITextField()
        secondTextField = UITextField()
        [degreeTextField, minuteTextField, secondTextField].forEach { (tf) in
            tf?.backgroundColor = .tertiarySystemBackground
            tf?.placeholder = "00"
            tf?.borderStyle = .none
            tf?.autocorrectionType = .no
            tf?.keyboardType = .numberPad
            tf?.layer.cornerRadius = 3
            tf?.font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .regular)
        }
        let degreeLabel = UILabel()
        degreeLabel.text = "°"
        let minuteLabel = UILabel()
        minuteLabel.text = "\""
        let secondLabel = UILabel()
        secondLabel.text = "'"
        [degreeLabel, minuteLabel, secondLabel].forEach {
            l in l.font = UIFont.systemFont(ofSize: 22)
        }
        let stackView = UIStackView(arrangedSubviews: [degreeTextField, degreeLabel, minuteTextField, minuteLabel, secondTextField, secondLabel])
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

