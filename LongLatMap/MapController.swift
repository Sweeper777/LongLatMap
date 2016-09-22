import GoogleMaps
import UIKit
import EZSwiftExtensions

class MapController: UIViewController, GMSMapViewDelegate, MarkerInfoControllerDelegate, SettingsControllerDelegate {
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
            gmsMarker.title = marker.title == "" || marker.title == nil ? NSLocalizedString("Unnamed", comment: "") : marker.title
            allMarkersMap[gmsMarker] = marker
        }
        let longitude = UserDefaults.standard.double(forKey: "lastLongitude")
        let latitude = UserDefaults.standard.double(forKey: "lastLatitude")
        let zoom = UserDefaults.standard.float(forKey: "lastZoom")
        let bearing = UserDefaults.standard.double(forKey: "lastBearing")
        let viewingAngle = UserDefaults.standard.double(forKey: "lastViewingAngle")
        mapView.animate(to: GMSCameraPosition(target: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoom: zoom, bearing: bearing, viewingAngle: viewingAngle))
        let mapType = MapType(rawValue: UserDefaults.standard.string(forKey: tagMapType)!)!
        mapView.mapType = MapType.mapTypeDict[mapType]!
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
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
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if shouldPlaceMarker {
            let marker = GMSMarker(position: coordinate)
            marker.isDraggable = true
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
            marker.icon = GMSMarker.markerImage(with: UIColor(hexString: Color.colorHexStrings[.Red]!))
            let markerModel = Marker(entity: CDUtils.markerEntity!, insertIntoManagedObjectContext: CDUtils.context, longitude: coordinate.longitude, latitude: coordinate.latitude, desc: "", title: "", color: "Red")
            marker.title = markerModel.title == "" || markerModel.title == nil ? NSLocalizedString("Unnamed", comment: "") : markerModel.title
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        Timer.runThisAfterDelay(seconds: 3) {
            [weak self] in
            (self?.view as! GMSMapView).selectedMarker = nil
        }
        return false
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
                marker.title = title == "" ? NSLocalizedString("Unnamed", comment: "") : title
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
            let title = formValues[tagTitle] as? String ?? NSLocalizedString("Unnamed", comment: "")
            let color = formValues[tagColor] as? Color ?? .Red
            let colorString = color.rawValue
            let markerModel = Marker(entity: CDUtils.markerEntity!, insertIntoManagedObjectContext: CDUtils.context, longitude: longitude, latitude: latitude, desc: desc, title: title, color: colorString)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.isDraggable = true
            marker.icon = GMSMarker.markerImage(with: UIColor(hexString: Color.colorHexStrings[color]!))
            marker.map = (self.view as! GMSMapView)
            marker.title = title == "" ? NSLocalizedString("Unnamed", comment: "") : title
            allMarkers.append(markerModel)
            allMarkersMap[marker] = markerModel
            CDUtils.saveData()
            
            let mapView = (self.view as! GMSMapView)
            mapView.animate(to: GMSCameraPosition(target: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoom: mapView.camera.zoom, bearing: mapView.camera.bearing, viewingAngle: mapView.camera.viewingAngle))
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
    
    func settingsController(_ settingsController: SettingsController, mapTypeChangedTo value: String) {
        (self.view as! GMSMapView).mapType = MapType.mapTypeDict[MapType(rawValue: value)!]!
    }
    
    func settingsController(_ settingsController: SettingsController, flatMarkerChangedTo value: Bool) {
        for marker in allMarkersMap.keys {
            marker.isFlat = value
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DataPasserController {
            vc.settingsDelegate = self
        }
    }
    
    deinit {
        let mapView = self.view as! GMSMapView
        UserDefaults.standard.set(mapView.camera.target.longitude, forKey: "lastLongitude")
        UserDefaults.standard.set(mapView.camera.target.latitude, forKey: "lastLatitude")
        UserDefaults.standard.set(mapView.camera.zoom, forKey: "lastZoom")
        UserDefaults.standard.set(mapView.camera.bearing, forKey: "lastBearing")
        UserDefaults.standard.set(mapView.camera.viewingAngle, forKey: "lastViewingAngle")
    }
}

