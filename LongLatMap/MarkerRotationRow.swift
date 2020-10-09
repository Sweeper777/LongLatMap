import Eureka
import GoogleMaps

public struct MarkerRotationRowValue: Equatable {
    var rotationDegrees: Int
    var markerColor: String
}

public class MarkerRotationCell: Cell<MarkerRotationRowValue>, CellType {

    @IBOutlet var markerView: UIImageView!
    
    public override func setup() {
        super.setup()
        let panRecogniser = UIPanGestureRecognizer(target: self, action: #selector(markerRotated(_:)))
        let touchRecogniser = UITapGestureRecognizer(target: self, action: #selector(markerRotated(_:)))
        self.addGestureRecognizer(panRecogniser)
        self.addGestureRecognizer(touchRecogniser)
        markerView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        markerView.image = GMSMarker.markerImage(with: .red)
        selectionStyle = .none
    }
    
    @objc func markerRotated(_ panGR: UIGestureRecognizer) {
        guard panGR.numberOfTouches > 0 else { return }
        let panPoint = panGR.location(ofTouch: 0, in: self)
        let centre = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let (x, y) = (x: panPoint.x - centre.x, y: centre.y - panPoint.y)
        let angle = atan2(x, y)
        let degrees = Int(round(angle / .pi * 180))
        row.value?.rotationDegrees = degrees
        row.updateCell()
    }
    
    public override func update() {
        super.update()
        setMarkerRotation(to: row.value?.rotationDegrees ?? 0)
    }
    
    func setMarkerRotation(to degrees: Int) {
        let radians = degrees.f / 180 * .pi
        markerView.transform = CGAffineTransform(rotationAngle: radians)
    }
}

class MarkerRotationCellBackgroundView: UIView {
    override func draw(_ rect: CGRect) {
        let centre = CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
        let circleRect = centre.insetBy(dx: -50, dy: -50)
        let path = UIBezierPath(ovalIn: circleRect)
        UIColor.tertiarySystemGroupedBackground.setFill()
        path.fill()
    }
}

public final class MarkerRotationRow: Row<MarkerRotationCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<MarkerRotationCell>(nibName: "MarkerRotationCell")
    }
}
