import Eureka

public class MarkerRotationCell: Cell<Int>, CellType {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var markerView: UIImageView!
    
}

public final class MarkerRotationRow: Row<MarkerRotationCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<MarkerRotationCell>(nibName: "MarkerRotationCell")
    }
}
