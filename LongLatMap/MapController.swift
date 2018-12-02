import GoogleMaps
import UIKit
import EZSwiftExtensions
import GoogleMobileAds
import MLScreenshot

class MapController: UIViewController, GMSMapViewDelegate, MarkerInfoControllerDelegate, SettingsControllerDelegate, GADInterstitialDelegate {
    static var shared: MapController!
    var shouldPlaceMarker = true
    var allMarkersMap: [GMSMarker: Marker] = [:]
    var allMarkers: [Marker]!
    var lastSelectedMarker: GMSMarker?
    
    var interstitialAd: GADInterstitial!
    
    var polyline: GMSPolyline!
    
    override func viewDidLoad() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 3)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        MapController.shared = self
        
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
            gmsMarker.snippet = marker.description
            gmsMarker.isFlat = UserDefaults.standard.bool(forKey: tagFlatMarkers)
            gmsMarker.rotation = marker.rotation?.doubleValue ?? 0
            allMarkersMap[gmsMarker] = marker
        }
        let longitude = UserDefaults.standard.double(forKey: "lastLongitude")
        let latitude = UserDefaults.standard.double(forKey: "lastLatitude")
        let zoom = UserDefaults.standard.float(forKey: "lastZoom")
        let bearing = UserDefaults.standard.double(forKey: "lastBearing")
        let viewingAngle = UserDefaults.standard.double(forKey: "lastViewingAngle")
        mapView.animate(to: GMSCameraPosition(target: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoom: zoom, bearing: bearing, viewingAngle: viewingAngle))
        let mapType = MapType(rawValue: UserDefaults.standard.string(forKey: tagMapType) ?? "Normal")!
        mapView.mapType = MapType.mapTypeDict[mapType]!
        mapView.settings.compassButton = true
        
        interstitialAd = GADInterstitial(adUnitID: adUnitID)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        interstitialAd.delegate = self
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: -89, longitude: -122))
        path.add(CLLocationCoordinate2D(latitude: 0, longitude: -122))
        path.add(CLLocationCoordinate2D(latitude: 89, longitude: -122))
        polyline = GMSPolyline(path: path)
        polyline.geodesic = true
        polyline.strokeColor = .red
        polyline.strokeWidth = 3
        polyline.map = mapView
        
        let rect = GMSMutablePath()
        rect.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
        rect.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.0))
        rect.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.2))
        rect.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.2);
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
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
            marker.icon = GMSMarker.markerImage(with: UIColor(hexString: Color.colorHexStrings[.red]!))
            let markerModel = Marker(entity: CDUtils.markerEntity!, insertIntoManagedObjectContext: CDUtils.context, longitude: coordinate.longitude, latitude: coordinate.latitude, desc: "", title: "", color: "Red", rotation: 0)
            marker.title = markerModel.title == "" || markerModel.title == nil ? NSLocalizedString("Unnamed", comment: "") : markerModel.title
            marker.snippet = markerModel.description
            marker.isFlat = UserDefaults.standard.bool(forKey: tagFlatMarkers)
            allMarkersMap[marker] = markerModel
            allMarkers.append(markerModel)
            CDUtils.saveData()
            if arc4random_uniform(100) < 10 && interstitialAd?.isReady ?? false {
                interstitialAd.present(fromRootViewController: self)
            }
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
        marker.snippet = markerModel.description
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
               
                Timer.runThisAfterDelay(seconds: 0.5) {
                     marker.position = CLLocationCoordinate2DMake(latitude, longitude)
                }
                
                markerModel.longitude = longitude as NSNumber?
                markerModel.latitude = latitude as NSNumber?
                Timer.runThisAfterDelay(seconds: 0.5) {
                    marker.snippet = markerModel.description
                }
            }
            
            if let color = formValues[tagColor] as? Color {
                marker.icon = GMSMarker.markerImage(with: UIColor(hexString: Color.colorHexStrings[color]!))
                markerModel.color = color.rawValue
            }
            
            if let title = formValues[tagTitle] as? String {
                markerModel.title = title
                marker.title = title == "" ? NSLocalizedString("Unnamed", comment: "") : title
                marker.isFlat = UserDefaults.standard.bool(forKey: tagFlatMarkers)
            }
            
            if let desc = formValues[tagDescription] as? String {
                markerModel.desc = desc
            }
            
            if let rotation = formValues[tagRotation] as? Float {
                markerModel.rotation = rotation as NSNumber
                Timer.runThisAfterDelay(seconds: 0.5) {
                    marker.rotation = CLLocationDegrees(rotation)
                }
            }
            CDUtils.saveData()
        } else {
            let formValues = markerInfoController.form.values()
            let longitude = formValues[tagLongitude] as! Double
            let latitude = formValues[tagLatitude] as! Double
            let desc = formValues[tagDescription] as? String ?? ""
            let title = formValues[tagTitle] as? String ?? NSLocalizedString("Unnamed", comment: "")
            let rotation = formValues[tagRotation] as? Float ?? 0
            let color = formValues[tagColor] as? Color ?? .red
            let colorString = color.rawValue
            let markerModel = Marker(entity: CDUtils.markerEntity!, insertIntoManagedObjectContext: CDUtils.context, longitude: longitude, latitude: latitude, desc: desc, title: title, color: colorString, rotation: rotation)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.isDraggable = true
            marker.icon = GMSMarker.markerImage(with: UIColor(hexString: Color.colorHexStrings[color]!))
            marker.map = (self.view as! GMSMapView)
            marker.title = title == "" ? NSLocalizedString("Unnamed", comment: "") : title
            marker.isFlat = UserDefaults.standard.bool(forKey: tagFlatMarkers)
            marker.rotation = CLLocationDegrees(rotation)
            marker.snippet = markerModel.description
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
    
    func settingsController(_ settingsController: SettingsController, longLatStyleChangedTo value: Int) {
        for (_, element) in allMarkersMap.enumerated() {
            element.key.snippet = element.value.description
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
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if arc4random_uniform(100) < 4 && interstitialAd?.isReady ?? false {
            interstitialAd.present(fromRootViewController: self)
        }
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial!) {
        interstitialAd = GADInterstitial(adUnitID: adUnitID)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        interstitialAd.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DataPasserController {
            vc.settingsDelegate = self
        }
    }
    
    @IBAction func screenshot(_ sender: Any) {
        if let image = view.screenshot() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            let alert = UIAlertController(title: NSLocalizedString("Screenshot Saved", comment: ""), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
            self.presentVC(alert)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Unable to save screenshot", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
            self.presentVC(alert)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let mapView = self.view as! GMSMapView
        UserDefaults.standard.set(mapView.camera.target.longitude, forKey: "lastLongitude")
        UserDefaults.standard.set(mapView.camera.target.latitude, forKey: "lastLatitude")
        UserDefaults.standard.set(mapView.camera.zoom, forKey: "lastZoom")
        UserDefaults.standard.set(mapView.camera.bearing, forKey: "lastBearing")
        UserDefaults.standard.set(mapView.camera.viewingAngle, forKey: "lastViewingAngle")
        UserDefaults.standard.synchronize()
    }
}

