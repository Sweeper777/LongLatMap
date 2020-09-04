import UIKit
import GoogleMaps
import SwiftyUtils

class MapViewController: UIViewController {
    var mapView: GMSMapView!
    var gmsMarkers = [GMSMarker]()
    
    override func viewDidLoad() {
        mapView = GMSMapView()
        view = mapView
    }
    
    func reloadMarkers() {
        gmsMarkers.forEach {
            $0.map = nil
        }
        gmsMarkers = DataManager.shared.markers.map { marker in
            let gmsMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude))
            gmsMarker.icon = GMSMarker.markerImage(with: UIColor(hex: marker.color))
            gmsMarker.rotation = marker.rotation
            gmsMarker.map = mapView
            return gmsMarker
        }
    }
}
