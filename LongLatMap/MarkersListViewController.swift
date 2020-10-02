import UIKit
import GoogleMaps

class MarkersListViewController: UITableViewController {
    var allMarkers = DataManager.shared.markers
    
    override func viewDidLoad() {
        title = "My Markers".localised
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take me there".localised, style: .default, handler: { (_) in
            tableView.deselectRow(at: indexPath, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Edit".localised, style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "showMarkerEditor", sender: self.allMarkers[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel".localised, style: .cancel, handler: { (_) in
            tableView.deselectRow(at: indexPath, animated: true)
        }))
        actionSheet.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        actionSheet.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MarkerEditorViewController,
            let marker = sender as? Marker {
            vc.marker = marker
        }
    }
    
    @IBAction func doneTapped() {
        performSegue(withIdentifier: "unwindToMap", sender: nil)
    }
}
