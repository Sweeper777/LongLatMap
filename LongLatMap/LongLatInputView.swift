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
    
    private func commonInit() {
        modeSelector = UISegmentedControl(items: ["DMS".localised, "Decimal".localised])
        modeSelector.selectedSegmentIndex = 0
        okButton = UIButton(type: .custom)
        okButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        dmsInput = DMSLongLatInputView()
        
        let stackView = UIStackView(arrangedSubviews: [modeSelector, dmsInput, okButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .secondarySystemBackground
    }
}
