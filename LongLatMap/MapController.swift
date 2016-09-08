import GoogleMaps
import UIKit

class MapController: UIViewController, GMSMapViewDelegate {
    
    override func viewDidLoad() {
        let camera = GMSCameraPosition.cameraWithLatitude(0, longitude: 0, zoom: 3)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        let alert = UIAlertController(title: NSLocalizedString("Location:", comment: ""), message: "\(NSLocalizedString("Longitude:", comment: "")) \(marker.position.longitude)\n\(NSLocalizedString("Latitude:", comment: "")) \(marker.position.latitude)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
        presentVC(alert)
        return true
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
}

