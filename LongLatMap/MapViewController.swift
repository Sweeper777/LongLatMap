import UIKit
import GoogleMaps
import SwiftyUtils

class MapViewController: UIViewController {
    var mapView: GMSMapView!
    var gmsMarkers = [GMSMarker]()
    
    override func viewDidLoad() {
        mapView = GMSMapView()
        view = mapView
        mapView.delegate = self
        reloadMarkers()
    }
    
    func reloadMarkers() {
        gmsMarkers.forEach {
            $0.map = nil
        }
        gmsMarkers = DataManager.shared.markers.map { marker in
            let gmsMarker = GMSMarker(position: marker.location)
            gmsMarker.icon = GMSMarker.markerImage(with: UIColor(hex: marker.color))
            gmsMarker.rotation = Double(marker.rotation)
            gmsMarker.map = mapView
            gmsMarker.title = marker.title
            gmsMarker.snippet = marker.desc
            gmsMarker.userData = marker.id
            return gmsMarker
        }
    }
}

extension MapViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let newMarker = Marker()
        newMarker.location = coordinate
        try? DataManager.shared.addMarker(newMarker)
        reloadMarkers()
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let index = gmsMarkers.indexes(of: marker).first else {
            return
        }
        performSegue(withIdentifier: "showMarkerEditor", sender: DataManager.shared.markers[index])
    }
}
