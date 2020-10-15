import UIKit
import GoogleMaps
import SwiftyUtils

import LiquidButton

class MapViewController: UIViewController {
    var mapView: GMSMapView!
    var gmsMarkers = [GMSMarker]()
    var longLatLabel: UILabel!
    var mapCrosshairView: MapCrosshairView!
    
    var latitudeLines = [GMSPolyline]()
    var longitudeLines = [GMSPolyline]()
    
    var floatingButtonCells = [
        LiquidFloatingCell(icon: UIImage(systemName: "plus")!),
        LiquidFloatingCell(icon: UIImage(systemName: "list.bullet")!),
        LiquidFloatingCell(icon: UIImage(systemName: "mappin.and.ellipse")!),
        LiquidFloatingCell(icon: UIImage(systemName: "gear")!),
    ]
    
    override func viewDidLoad() {
        mapView = GMSMapView()
        view = mapView
        mapView.delegate = self
        mapView.mapType = MapType.mapTypeDict[UserSettings.mapType]!
        
        reloadMarkers()
        
        addGraticules()
        
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        let liquidButton = LiquidFloatingActionButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.addSubview(liquidButton)
        liquidButton.translatesAutoresizingMaskIntoConstraints = false
        liquidButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        liquidButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        liquidButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        liquidButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        liquidButton.delegate = self
        liquidButton.dataSource = self
        liquidButton.color = UIColor(hex: "3b7b3b")
        liquidButton.image = UIImage(named: "chevron")
        liquidButton.rotationDegrees = 180
        mapView.bringSubviewToFront(liquidButton)
        
        longLatLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        view.addSubview(longLatLabel)
        longLatLabel.translatesAutoresizingMaskIntoConstraints = false
        longLatLabel.backgroundColor = UIColor(hex: "3b7b3b")
        longLatLabel.layer.masksToBounds = true
        longLatLabel.layer.cornerRadius = 15
        longLatLabel.textColor = .white
        longLatLabel.layer.shadowOpacity = 1
        longLatLabel.layer.shadowRadius = 10
        longLatLabel.layer.shadowOffset = .zero
        longLatLabel.layer.shadowColor = UIColor.black.cgColor
        NSLayoutConstraint.activate([
            longLatLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            longLatLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            longLatLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        updateLongLatLabel(toCoordinate: mapView.projection.coordinate(for: mapView.center))
        
        mapCrosshairView = MapCrosshairView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.addSubview(mapCrosshairView)
        mapCrosshairView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapCrosshairView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapCrosshairView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapCrosshairView.widthAnchor.constraint(equalToConstant: 30),
            mapCrosshairView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func addGraticules() {
        longitudeLines = (-179...180).map { (l: Int) -> GMSPolyline in
            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: 89, longitude: Double(l)))
            path.add(CLLocationCoordinate2D(latitude: -89, longitude: Double(l)))
            return GMSPolyline(path: path)
        }
        latitudeLines = (-89...89).map { (l: Int) -> GMSPolyline in
            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: Double(l), longitude: -179.9))
            path.add(CLLocationCoordinate2D(latitude: Double(l), longitude: 0))
            path.add(CLLocationCoordinate2D(latitude: Double(l), longitude: 179.9))
            return GMSPolyline(path: path)
        }
        (longitudeLines + latitudeLines).forEach {
            $0.map = mapView
            $0.geodesic = false
            $0.strokeWidth = 0.5
            $0.strokeColor = UIColor(white: 0, alpha: 0.5)
        }
        for i in latitudeLines.indices where i % 10 == 9 {
            latitudeLines[i].strokeWidth = 1
        }
        for i in longitudeLines.indices where i % 10 == 9 {
            longitudeLines[i].strokeWidth = 1
        }
    }
    
    func updateGMSMarker(_ gmsMarker: GMSMarker, accordingTo marker: Marker) {
        gmsMarker.position = marker.location
        gmsMarker.icon = GMSMarker.markerImage(with: UIColor(hex: marker.color))
        gmsMarker.rotation = Double(marker.rotation)
        gmsMarker.map = mapView
        gmsMarker.title = marker.title
        let latitudeString = LongLatFormatter.sharedLatitudeFormatter.string(for: marker.latitude)
        let longtitudeString = LongLatFormatter.sharedLongitudeFormatter.string(for: marker.longitude)
        gmsMarker.snippet = "\(latitudeString) \(longtitudeString)\n\(marker.desc)"
        gmsMarker.userData = marker.id
        gmsMarker.isDraggable = true
        gmsMarker.isFlat = UserSettings.flatMarkers
    }
    
    func updateGraticules() {
        if UserSettings.showGraticules {
            latitudeLines.forEach { (line) in
                line.strokeColor = .black
            }
            longitudeLines.forEach { (line) in
                line.strokeColor = .black
            }
        } else {
            latitudeLines.forEach { (line) in
                line.strokeColor = .clear
            }
            longitudeLines.forEach { (line) in
                line.strokeColor = .clear
            }
        }
    }
    
    func reloadMarkers() {
        gmsMarkers.forEach {
            $0.map = nil
        }
        gmsMarkers = DataManager.shared.markers.map { marker in
            let gmsMarker = GMSMarker()
            updateGMSMarker(gmsMarker, accordingTo: marker)
            return gmsMarker
        }
    }
    
    func selectMarker(_ marker: Marker) {
        guard let gmsMarker = gmsMarkers.first(where: { ($0.userData as? Int) == marker.id }) else {
            return
        }
        mapView.selectedMarker = gmsMarker
        mapView.animate(toLocation: marker.location)
    }
    
    func updateLongLatLabel(toCoordinate coord: CLLocationCoordinate2D) {
        let location = coord
        let latitudeString = LongLatFormatter.sharedLatitudeFormatter.string(for: location.latitude)
        let longtitudeString = LongLatFormatter.sharedLongitudeFormatter.string(for: location.longitude)
        longLatLabel.text = "    \(latitudeString) \(longtitudeString)    "
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = (segue.destination as? UINavigationController)?.topViewController as? MarkerEditorViewController {
            vc.marker = sender as? Marker
        } else if segue.identifier == "showMyMarkers" {
            segue.destination.presentationController?.delegate = self
        }
    }
    
    @IBAction func unwindFromModal(_ segue: UIStoryboardSegue) {
        if let editedMarker = (segue.source as? MarkerEditorViewController)?.marker {
            if let gmsMarker = gmsMarkers.first(where: { ($0.userData as? Int) == editedMarker.id }) {
                updateGMSMarker(gmsMarker, accordingTo: editedMarker)
            } else {
                let gmsMarker = GMSMarker()
                updateGMSMarker(gmsMarker, accordingTo: editedMarker)
                gmsMarkers.append(gmsMarker)
            }
            mapView.animate(toLocation: editedMarker.location)
        } else {
            reloadMarkers()
            mapView.mapType = MapType.mapTypeDict[
                MapType(rawValue: UserDefaults.standard.string(forKey: tagMapType) ?? "Normal") ?? .normal
            ]!
            updateLongLatLabel(toCoordinate: mapView.projection.coordinate(for: mapView.center))
            if let markerToGoTo = (segue.source as? MarkersListViewController)?.selectedMarker {
                selectMarker(markerToGoTo)
            }
        }
    }
}
