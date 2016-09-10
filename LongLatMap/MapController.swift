import GoogleMaps
import UIKit

class MapController: UIViewController, GMSMapViewDelegate {
    var shouldPlaceMarker = true
    
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
//        let alert = UIAlertController(title: NSLocalizedString("Location:", comment: ""), message: "\(NSLocalizedString("Longitude:", comment: "")) \(marker.position.longitude)\n\(NSLocalizedString("Latitude:", comment: "")) \(marker.position.latitude)", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
//        presentVC(alert)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MarkerInfoController")
        vc.modalInPopover = true
        vc.modalPresentationStyle = .Popover
        
        let point = mapView.projection.pointForCoordinate(marker.position)
        
        vc.popoverPresentationController!.sourceRect = CGRectMake(point.x - 11, point.y - 39, 22, 39)
        vc.popoverPresentationController?.sourceView = self.view
        
        self.presentVC(vc)
        
        return true
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        if shouldPlaceMarker {
            let marker = GMSMarker(position: coordinate)
            marker.draggable = true
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
        }
    }
    
    func mapView(mapView: GMSMapView, didBeginDraggingMarker marker: GMSMarker) {
        shouldPlaceMarker = false
    }
    
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        shouldPlaceMarker = true
    }
}

