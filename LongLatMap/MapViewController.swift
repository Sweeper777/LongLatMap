import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    var mapView: GMSMapView!
    override func viewDidLoad() {
        mapView = GMSMapView()
        view = mapView
    }
}
