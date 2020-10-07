import UIKit

class MapCrosshairView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        path.lineWidth = 2
        UIColor.black.setStroke()
        path.stroke()
    }
}
