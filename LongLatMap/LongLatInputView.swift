import UIKit
import CoreLocation

class LongLatInputView : UIView {
    var modeSelector: UISegmentedControl!
    var okButton: UIButton!
    var dmsInput: DMSLongLatInputView!
    var decimalInput: DecimalLongLatInputView!
    
    weak var delegate: LongLatInputViewDelegate?
    
    enum Mode {
        case longitude
        case latitude
    }
    
    private var dmsInputMode: Mode {
        get { dmsInput.mode }
        set { dmsInput.mode = newValue }
    }
    
    private var decimalInputMode: Mode {
        get { decimalInput.mode }
        set { decimalInput.mode = newValue }
    }
    
    var mode: Mode {
        get {
            if modeSelector.selectedSegmentIndex == 0 {
                return dmsInputMode
            } else {
                return decimalInputMode
            }
        }
        set {
            dmsInputMode = newValue
            decimalInputMode = newValue
        }
    }
    
    var degrees: CLLocationDegrees? {
        get {
            if modeSelector.selectedSegmentIndex == 0 {
                return dmsInput.degrees
            } else {
                return decimalInput.degrees
            }
        }
        set {
            dmsInput.degrees = newValue
            decimalInput.degrees = newValue
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
        modeSelector = UISegmentedControl(items: ["DMS".localised, "Decimal".localised])
        modeSelector.selectedSegmentIndex = 0
        modeSelector.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        
        okButton = UIButton(type: .custom)
        okButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        
        dmsInput = DMSLongLatInputView()
        decimalInput = DecimalLongLatInputView()
        decimalInput.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [modeSelector, dmsInput, decimalInput, okButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        decimalInput.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -16).isActive = true
        dmsInput.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -16).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .secondarySystemBackground
    }
    
    @objc func modeChanged() {
        if modeSelector.selectedSegmentIndex == 0 {
            dmsInput.isHidden = false
            decimalInput.isHidden = true
            
            if let decimalDegrees = decimalInput.degrees {
                dmsInput.degrees = decimalDegrees
            }
            if decimalInput.isFirstResponder {
                _ = dmsInput.becomeFirstResponder()
            }
        } else {
            dmsInput.isHidden = true
            decimalInput.isHidden = false
            
            if let dmsDegrees = dmsInput.degrees {
                decimalInput.degrees = dmsDegrees
            }
            if dmsInput.isFirstResponder {
                _ = decimalInput.becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        if modeSelector.selectedSegmentIndex == 0 {
            return dmsInput.becomeFirstResponder()
        } else {
            return decimalInput.becomeFirstResponder()
        }
    }
    
    @objc func okTapped() {
        degrees.map { delegate?.didSelectDegrees($0) }
    }
}

protocol LongLatInputViewDelegate : class {
    func didSelectDegrees(_ degrees: CLLocationDegrees)
}
