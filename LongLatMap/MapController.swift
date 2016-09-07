import MapKit
import UIKit

class MapController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var longPressRecog: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(longPressRecog)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.locationInView(view)
        let coordinate = mapView.convertPoint(point, toCoordinateFromView: view)
        let anno = MKPointAnnotation()
        anno.coordinate = coordinate
        anno.title = "\(NSLocalizedString("Longitude", comment: "")): \(coordinate.longitude)"
        anno.subtitle = "\(NSLocalizedString("Latitude", comment: "")): \(coordinate.latitude)"
        mapView.addAnnotation(anno)
    }
}

