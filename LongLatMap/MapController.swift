import GoogleMaps
import UIKit
import EZSwiftExtensions

class MapController: UIViewController, GMSMapViewDelegate, MarkerInfoControllerDelegate {
    var shouldPlaceMarker = true
    var allMarkersMap: [GMSMarker: Marker] = [:]
    var allMarkers: [Marker]!
    var lastSelectedMarker: GMSMarker?
    
    override func viewDidLoad() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 3)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        mapView.delegate = self
        
        self.allMarkers = CDUtils.allMarkers
        for marker in self.allMarkers {
            let location = CLLocationCoordinate2DMake(marker.latitude!.doubleValue, marker.longitude!.doubleValue)
            let gmsMarker = GMSMarker(position: location)
            if let color = marker.color {
                let hexString = Color.colorHexStrings[Color(rawValue: color)!]!
                gmsMarker.icon = GMSMarker.markerImage(with: UIColor(hexString: hexString))
            } else {
                gmsMarker.icon = GMSMarker.markerImage(with: UIColor(hexString: "ff0000"))
            }
            gmsMarker.map = mapView
            allMarkersMap[gmsMarker] = marker
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        let alert = UIAlertController(title: NSLocalizedString("Location:", comment: ""), message: "\(NSLocalizedString("Longitude:", comment: "")) \(marker.position.longitude)\n\(NSLocalizedString("Latitude:", comment: "")) \(marker.position.latitude)", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
//        presentVC(alert)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MarkerInfoController")
        vc.modalPresentationStyle = .popover
        
        let point = mapView.projection.point(for: marker.position)
        
        vc.popoverPresentationController!.sourceRect = CGRect(x: point.x - 11, y: point.y - 39, width: 22, height: 39)
        vc.popoverPresentationController?.sourceView = self.view
        
        (vc as! DataPasserController).marker = allMarkersMap[marker]
        (vc as! DataPasserController).markerInfoDelegate = self
        self.presentVC(vc)
        
        self.lastSelectedMarker = marker
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if shouldPlaceMarker {
            let marker = GMSMarker(position: coordinate)
            marker.isDraggable = true
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
            marker.icon = GMSMarker.markerImage(with: UIColor(hexString: Color.colorHexStrings[.Red]!))
            let markerModel = Marker(entity: CDUtils.markerEntity!, insertIntoManagedObjectContext: CDUtils.context, longitude: coordinate.longitude, latitude: coordinate.latitude, desc: "", title: "", color: "Red")
            allMarkersMap[marker] = markerModel
            allMarkers.append(markerModel)
            CDUtils.saveData()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        shouldPlaceMarker = false
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        shouldPlaceMarker = true
        let markerModel = allMarkersMap[marker]!
        markerModel.longitude = marker.position.longitude as NSNumber?
        markerModel.latitude = marker.position.latitude as NSNumber?
        CDUtils.saveData()
    }
    
    func controllerDismissed(_ markerInfoController: MarkerInfoController) {
        if let marker = lastSelectedMarker {
            let formValues = markerInfoController.form.values()
            let markerModel = allMarkersMap[marker]!
            if let longitude = formValues[tagLongitude] as? Double,
                let latitude = formValues[tagLatitude] as? Double {
                marker.position = CLLocationCoordinate2DMake(latitude, longitude)
                markerModel.longitude = longitude as NSNumber?
                markerModel.latitude = latitude as NSNumber?
            }
            
            if let color = formValues[tagColor] as? Color {
                marker.icon = GMSMarker.markerImage(with: UIColor(hexString: Color.colorHexStrings[color]!))
                markerModel.color = color.rawValue
            }
            
            if let title = formValues[tagTitle] as? String {
                markerModel.title = title
            }
            
            if let desc = formValues[tagDescription] as? String {
                markerModel.desc = desc
            }
            CDUtils.saveData()
        } else {
            let formValues = markerInfoController.form.values()
            let longitude = formValues[tagLongitude] as! Double
            let latitude = formValues[tagLatitude] as! Double
            let desc = formValues[tagDescription] as? String ?? ""
            let title = formValues[tagTitle] as? String ?? ""
            let color = formValues[tagColor] as? Color ?? .Red
            let colorString = color.rawValue
            let markerModel = Marker(entity: CDUtils.markerEntity!, insertIntoManagedObjectContext: CDUtils.context, longitude: longitude, latitude: latitude, desc: desc, title: title, color: colorString)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.isDraggable = true
            marker.icon = GMSMarker.markerImage(with: UIColor(hexString: Color.colorHexStrings[color]!))
            marker.map = (self.view as! GMSMapView)
            allMarkers.append(markerModel)
            allMarkersMap[marker] = markerModel
            CDUtils.saveData()
            
            (self.view as! GMSMapView).animate(to: GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: (self.view as! GMSMapView).camera.zoom))
        }
        lastSelectedMarker = nil
    }
    
    func markerDeleted(_ markerInfoController: MarkerInfoController) {
        CDUtils.context.delete(markerInfoController.marker!)
        allMarkersMap.removeValue(forKey: lastSelectedMarker!)
        allMarkers.removeObject(markerInfoController.marker!)
        lastSelectedMarker?.map = nil
        lastSelectedMarker = nil
        CDUtils.saveData()
    }
    
    @IBAction func addMarker(_ sender: UIBarButtonItem) {
        lastSelectedMarker = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MarkerInfoController")
        vc.modalPresentationStyle = .popover
        
        vc.popoverPresentationController!.barButtonItem = sender
        
        (vc as! DataPasserController).markerInfoDelegate = self
        self.presentVC(vc)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.2) {
            if self.navBar!.alpha == 1 {
                self.navBar!.alpha = 0
            } else {
                self.navBar!.alpha = 1
            }
        }
    }
}

