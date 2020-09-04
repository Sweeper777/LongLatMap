import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    var mapView: GMSMapView!
    override func viewDidLoad() {
        mapView = GMSMapView()
        view = mapView
        if traitCollection.userInterfaceStyle == .dark {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: Bundle.main.url(forResource: "darkMapStyle", withExtension: "json")!)
        } else {
            mapView.mapStyle = nil
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: Bundle.main.url(forResource: "darkMapStyle", withExtension: "json")!)
        } else {
            mapView.mapStyle = nil
        }
    }
}
