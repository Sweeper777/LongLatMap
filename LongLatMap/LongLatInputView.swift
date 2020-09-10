import UIKit

class LongLatInputView : UIView {
    var modeSelector: UISegmentedControl!
    var okButton: UIButton!
    var dmsInput: DMSLongLatInputView!
    var decimalInput: DecimalLongLatInputView!
    
    var dmsInputMode: DMSLongLatInputView.Mode {
        get { dmsInput.mode }
        set { dmsInput.mode = newValue }
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
        modeSelector = UISegmentedControl(items: ["DMS".localised, "Decimal".localised])
        modeSelector.selectedSegmentIndex = 0
        modeSelector.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        
        okButton = UIButton(type: .custom)
        okButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        dmsInput = DMSLongLatInputView()
        decimalInput = DecimalLongLatInputView()
        decimalInput.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [modeSelector, dmsInput, decimalInput, okButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        decimalInput.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -16).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .secondarySystemBackground
    }
    
    @objc func modeChanged() {
        if modeSelector.selectedSegmentIndex == 0 {
            dmsInput.isHidden = false
            decimalInput.isHidden = true
        } else {
            dmsInput.isHidden = true
            decimalInput.isHidden = false
        }
    }
}
