import GoogleMaps
import LiquidButton
import GoogleMobileAds

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
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        updateLongLatLabel(toCoordinate: mapView.projection.coordinate(for: mapView.center))
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        guard let index = gmsMarkers.indexes(of: marker).first else {
            return
        }
        let markerInRealm = DataManager.shared.markers[index]
        do {
            try DataManager.shared.updateMarker(markerInRealm, latitude: marker.position.latitude, longitude: marker.position.longitude)
            updateGMSMarker(marker, accordingTo: markerInRealm)
        } catch {
            updateGMSMarker(marker, accordingTo: markerInRealm)
        }
    }

    public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if Int.random(in: 0..<100) < 5 && interstitialAd?.isReady ?? false {
            interstitialAd.present(fromRootViewController: self)
        }
    }
}

extension MapViewController : LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource {
    func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        4
    }
    
    func cellForIndex(_ index: Int) -> LiquidFloatingCell {
        floatingButtonCells[index]
    }
    
    fileprivate func dropMarker() {
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        let newMarker = Marker()
        newMarker.location = coordinate
        try? DataManager.shared.addMarker(newMarker)
        reloadMarkers()
    }
    
    func liquidFloatingActionButton(_ liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        switch index {
        case 0:
            performSegue(withIdentifier: "showMarkerEditor", sender: nil)
        case 1:
            performSegue(withIdentifier: "showMyMarkers", sender: nil)
        case 2:
            dropMarker()
        case 3:
            performSegue(withIdentifier: "showSettings", sender: nil)
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

extension MapViewController : GADInterstitialDelegate {
    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        reloadAds()
    }
}