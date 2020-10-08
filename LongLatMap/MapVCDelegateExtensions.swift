import GoogleMaps
import LiquidButton

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
        switch index {
        case 0:
            performSegue(withIdentifier: "showMarkerEditor", sender: nil)
        case 1:
            performSegue(withIdentifier: "showMyMarkers", sender: nil)
        case 2:
        default:
            break
        }
    }
}

extension MapViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        reloadMarkers()
    }
}
