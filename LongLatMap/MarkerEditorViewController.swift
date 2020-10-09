import UIKit
import Eureka
import ColorPickerRow
import SCLAlertView

class MarkerEditorViewController: FormViewController {
    
    var marker: Marker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = marker?.title ?? "New Marker".localised
        if !isRootInNavigationController {
            navigationItem.leftBarButtonItems = []
        }
        
        form +++ Section("location".localised)
        <<< LongLatRow(tagLatitude) {
            row in
            row.title = "Latitude".localised
            row.value = marker?.latitude ?? 0
        }
        <<< LongLatRow(tagLongitude) {
            row in
            row.title = "Longitude".localised
            row.mode = .longitude
            row.value = marker?.longitude ?? 0
        }.onPresent({ (form, presented) in
            if let longLatInputVC = presented as? LongLatInputController {
                longLatInputVC.mode = .longitude
            }
        })
        
        form +++ Section()
        <<< ColorPickerRow(tagColor) {
            row in
            row.title = "Color".localised
            row.value = (marker?.color).map(UIColor.init(hex:)) ?? .red
            row.showsPaletteNames = false
        }.cellSetup({ (cell, row) in
            cell.palettes = Color.allCases.map {
                ColorPalette(name: $0.description, palette: [
                    ColorSpec(hex: "#" + $0.hexString, name: $0.description)
                ])
            }
        }).onChange({ (row) in
            let rotationRow = self.form.rowBy(tag: tagRotation) as! RowOf<MarkerRotationRowValue>
            rotationRow.value = MarkerRotationRowValue(rotationDegrees: rotationRow.value?.rotationDegrees ?? 0, markerColor: row.value ?? .red)
            rotationRow.updateCell()
        })
            
        <<< LabelRow(tagRotationLabel) {
            row in
            row.title = "Rotation".localised
            row.value = "\(marker?.rotation ?? 0)°"
        }
        <<< MarkerRotationRow(tagRotation) {
            row in
            row.value = MarkerRotationRowValue(rotationDegrees: marker?.rotation ?? 0,
                                               markerColor: marker.map(\.color).map(UIColor.init(hex:)) ?? .red)
            row.cell.height = { 112 }
        }.onChange {
            row in
            let labelRow = self.form.rowBy(tag: tagRotationLabel) as? RowOf<String>
            labelRow?.value = "\(row.value?.rotationDegrees ?? 0)°"
            labelRow?.updateCell()
        }
        
        form +++ TextRow(tagTitle) {
            row in
            row.title = "Title".localised
            row.value = marker?.title ?? "Unnamed".localised
        }
        
        form +++ Section("description".localised)
            
        <<< TextAreaRow(tagDescription) {
            row in
            row.value = marker?.desc ?? ""
        }
        
        if let markerToEdit = marker {
            form +++ ButtonRow {
                row in
                row.title = "Delete This Marker".localised
                row.cell.tintColor = .red
            }.onCellSelection({ [weak self] (cell, row) in
                let alert = SCLAlertView()
                alert.addButton("Yes".localised) { [weak self] in
                    guard let `self` = self else { return }
                    do {
                        try DataManager.shared.deleteMarker(markerToEdit)
                        self.marker = nil
                        self.performSegue(withIdentifier: "unwindToMap", sender: nil)
                    } catch {
                        SCLAlertView().showError("Error".localised, subTitle: "An error occurred while deleting marker!".localised, closeButtonTitle: "OK".localised)
                        print(error)
                    }
                }
                alert.showWarning("Confirm".localised, subTitle: "Do you really want to delete this marker?".localised, closeButtonTitle: "No".localised)
            })
        }
    }
    
    @IBAction func doneTapped() {
        let values = form.values()
        let latitude = values[tagLatitude] as? Double
        let longitude = values[tagLongitude] as? Double
        let rotation = values[tagRotation] as? Int
        let color = ((values[tagColor] as? UIColor)?.hexString(false).dropFirst()).map(String.init)
        let title = values[tagTitle] as? String
        let desc = values[tagDescription] as? String
        

        do {
            if let markerToEdit = marker {
                try DataManager.shared.updateMarker(markerToEdit,
                    latitude: latitude,
                    longitude: longitude,
                    rotation: rotation,
                    color: color,
                    title: title,
                    desc: desc
                )
            } else {
                let marker = Marker()
                marker.latitude = latitude ?? 0
                marker.longitude = longitude ?? 0
                marker.rotation = rotation ?? 0
                marker.color = color ?? Color.red.hexString
                marker.title = title ?? "Unnamed".localised
                marker.desc = desc ?? ""
                try DataManager.shared.addMarker(marker)
                self.marker = marker
            }
            goBack()
        } catch {
            SCLAlertView().showError("Error".localised, subTitle: "An error occurred while saving marker!".localised, closeButtonTitle: "OK".localised)
            print(error)
        }
    }
    
    var isRootInNavigationController: Bool {
        navigationController?.viewControllers.first == self
    }
    
    func goBack() {
        if isRootInNavigationController {
            performSegue(withIdentifier: "unwindToMap", sender: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
