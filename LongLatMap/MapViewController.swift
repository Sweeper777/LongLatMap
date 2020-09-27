import UIKit
import GoogleMaps
import SwiftyUtils

import LiquidButton

class MapViewController: UIViewController {
    var mapView: GMSMapView!
    var gmsMarkers = [GMSMarker]()
    
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
        reloadMarkers()
        
        addGraticules()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = (segue.destination as? UINavigationController)?.topViewController as? MarkerEditorViewController,
            let marker = sender as? Marker {
            vc.marker = marker
        }
    }
    
    @IBAction func unwindFromMarkerEditor(_ segue: UIStoryboardSegue) {
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

extension MapViewController : LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource {
    func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        4
    }
    
    func cellForIndex(_ index: Int) -> LiquidFloatingCell {
        floatingButtonCells[index]
    }
    
    func liquidFloatingActionButton(_ liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("Selected \(index)")
    }
}
