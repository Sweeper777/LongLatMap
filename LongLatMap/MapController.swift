import MapKit
import UIKit

class MapController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var longPressRecog: UILongPressGestureRecognizer!
    var pressedDown = false
    var pressedLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(longPressRecog)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLongPress(sender: UILongPressGestureRecognizer) {
        pressedDown = true
        pressedLocation = mapView.convertPoint(sender.locationInView(view), toCoordinateFromView: view)
        print(pressedLocation)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if pressedDown {
            print(pressedLocation)
            let anno = MKPointAnnotation()
            anno.coordinate = pressedLocation!
            anno.title = "\(NSLocalizedString("Longitude", comment: "")): \(pressedLocation!.longitude)"
            anno.subtitle = "\(NSLocalizedString("Latitude", comment: "")): \(pressedLocation!.latitude)"
            mapView.addAnnotation(anno)
            print(mapView.annotations)
        }
        
        pressedDown = false
        pressedLocation = nil
    }
}

