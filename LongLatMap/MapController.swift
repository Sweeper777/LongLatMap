import GoogleMaps
import UIKit

class MapController: UIViewController, GMSMapViewDelegate, MarkerInfoControllerDelegate {
    var shouldPlaceMarker = true
    var allMarkersMap: [GMSMarker: Marker] = [:]
    var allMarkers: [Marker]!
    var lastSelectedMarker: GMSMarker?
    
    override func viewDidLoad() {
        let camera = GMSCameraPosition.cameraWithLatitude(0, longitude: 0, zoom: 3)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        mapView.delegate = self
        
        self.allMarkers = CDUtils.allMarkers
        for marker in self.allMarkers {
            let location = CLLocationCoordinate2DMake(marker.latitude!.doubleValue, marker.longitude!.doubleValue)
            let gmsMarker = GMSMarker(position: location)
            if let color = marker.color {
                let hexString = Color.colorHexStrings[Color(rawValue: color)!]!
                gmsMarker.icon = GMSMarker.markerImageWithColor(UIColor(hexString: hexString))
            } else {
                gmsMarker.icon = GMSMarker.markerImageWithColor(UIColor(hexString: "ff0000"))
            }
            gmsMarker.map = mapView
            allMarkersMap[gmsMarker] = marker
        }
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
        
        (vc as! DataPasserController).marker = allMarkersMap[marker]
        (vc as! DataPasserController).markerInfoDelegate = self
        self.presentVC(vc)
        
        self.lastSelectedMarker = marker
        
        return true
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        if shouldPlaceMarker {
            let marker = GMSMarker(position: coordinate)
            marker.draggable = true
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
            marker.icon = GMSMarker.markerImageWithColor(UIColor(hexString: Color.colorHexStrings[.Red]!))
            let markerModel = Marker(entity: CDUtils.markerEntity!, insertIntoManagedObjectContext: CDUtils.context, longitude: coordinate.longitude, latitude: coordinate.latitude, desc: "", title: "", color: "Red")
            allMarkersMap[marker] = markerModel
            allMarkers.append(markerModel)
            CDUtils.saveData()
        }
    }
    
    func mapView(mapView: GMSMapView, didBeginDraggingMarker marker: GMSMarker) {
        shouldPlaceMarker = false
    }
    
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        shouldPlaceMarker = true
        let markerModel = allMarkersMap[marker]!
        markerModel.longitude = marker.position.longitude
        markerModel.latitude = marker.position.latitude
        CDUtils.saveData()
    }
    
    func controllerDismissed(markerInfoController: MarkerInfoController) {
        if let marker = lastSelectedMarker {
            let formValues = markerInfoController.form.values()
            if let longitude = formValues[tagLongitude] as? Double,
                let latitude = formValues[tagLatitude] as? Double {
                marker.position = CLLocationCoordinate2DMake(latitude, longitude)
            }
            
            if let color = formValues[tagColor] as? Color {
                marker.icon = GMSMarker.markerImageWithColor(UIColor(hexString: Color.colorHexStrings[color]!))
            }
        }
        lastSelectedMarker = nil
    }
}

