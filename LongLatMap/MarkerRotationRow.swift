import Eureka
import GoogleMaps

public class MarkerRotationCell: Cell<Int>, CellType {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var markerView: UIImageView!
    
    public override func setup() {
        super.setup()
        let gestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(markerPanned(_:)))
        self.addGestureRecognizer(gestureRecogniser)
        markerView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        markerView.image = GMSMarker.markerImage(with: .red)
        titleLabel.text = (row as! MarkerRotationRow).titleText
        selectionStyle = .none
    }
    
    @objc func markerPanned(_ panGR: UIPanGestureRecognizer) {
    }
    
    public override func update() {
        super.update()
        valueLabel.text = "\(row.value ?? 0)°"
        setMarkerRotation(to: row.value ?? 0)
    }
    
    func setMarkerRotation(to degrees: Int) {
        let radians = degrees.f / 180 * .pi
        markerView.transform = CGAffineTransform(rotationAngle: radians)
    }
}

public final class MarkerRotationRow: Row<MarkerRotationCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<MarkerRotationCell>(nibName: "MarkerRotationCell")
    }
    
    var titleText: String?
}
