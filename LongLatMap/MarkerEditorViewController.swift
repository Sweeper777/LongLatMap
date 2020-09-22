import UIKit
import Eureka
import ColorPickerRow
import SCLAlertView

class MarkerEditorViewController: FormViewController {
    
    var marker: Marker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = marker?.title ?? "New Marker".localised
        
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
        })
            
        <<< LabelRow(tagRotationLabel) {
            row in
            row.title = "Rotation".localised
            row.value = "\(marker?.rotation ?? 0)°"
        }
        <<< MarkerRotationRow(tagRotation) {
            row in
            row.value = marker?.rotation ?? 0
            row.cell.height = { 112 }
        }.onChange {
            row in
            let labelRow = self.form.rowBy(tag: tagRotationLabel) as? RowOf<String>
            labelRow?.value = "\(row.value ?? 0)°"
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
            row.value = marker?.description ?? ""
        }
    }
    
    @IBAction func doneTapped() {
        let values = form.values()
        let latitude = values[tagLatitude] as? Double
        let longitude = values[tagLongitude] as? Double
        let rotation = values[tagRotation] as? Int
        let color = (values[tagColor] as? UIColor)?.hexString()
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
                                                desc: desc)
            }
            dismiss(animated: true, completion: nil)
        } catch {
            SCLAlertView().showError("Error".localised, subTitle: "An error occurred while saving marker!".localised, closeButtonTitle: "OK".localised)
            print(error)
        }
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
