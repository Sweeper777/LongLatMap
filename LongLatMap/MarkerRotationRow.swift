import Eureka
import GoogleMaps

public class MarkerRotationCell: Cell<Int>, CellType {

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
        row.value = degrees
        row.updateCell()
    }
    
    public override func update() {
        super.update()
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
}
