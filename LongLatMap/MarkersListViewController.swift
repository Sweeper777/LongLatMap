import UIKit
import GoogleMaps

class MarkersListViewController: UITableViewController {
    var allMarkers = DataManager.shared.markers
    
    override func viewDidLoad() {
        title = "My Markers".localised
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allMarkers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let marker = allMarkers[indexPath.row]
        cell.textLabel?.text = marker.title
        let latitudeText = LongLatFormatter.sharedLatitudeFormatter.string(for: marker.latitude)
        let longitudeText = LongLatFormatter.sharedLongitudeFormatter.string(for: marker.longitude)
        cell.detailTextLabel?.text = "\(latitudeText) \(longitudeText)"
        cell.imageView?.image = GMSMarker.markerImage(with: UIColor(hex: marker.color))
        return cell
    }
}
