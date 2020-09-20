import UIKit
import Eureka
import ColorPickerRow

class MarkerEditorViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("location".localised)
        <<< LongLatRow(tagLatitude) {
            row in
            row.title = "Latitude".localised
            row.value = 0
        }
        <<< LongLatRow(tagLongitude) {
            row in
            row.title = "Longitude".localised
            row.mode = .longitude
            row.value = 0
        }.onPresent({ (form, presented) in
            if let longLatInputVC = presented as? LongLatInputController {
                longLatInputVC.mode = .longitude
            }
        })
        
        form +++ Section()
        <<< ColorPickerRow(tagColor) {
            row in
            row.title = "Color".localised
            row.value = .red
            row.showsPaletteNames = false
        }.cellSetup({ (cell, row) in
            cell.palettes = [
                ColorPalette(
                    name: "All",
                    palette: Color.allCases.map {
                        ColorSpec(hex: "#" + $0.hexString, name: $0.description)
                    }
                )
            ]
        })
            
        <<< LabelRow(tagRotationLabel) {
            row in
            row.title = "Rotation".localised
        }
        <<< MarkerRotationRow(tagRotation) {
            row in
            row.value = 90
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
            row.value = ""
        }
        
        form +++ Section("description".localised)
            
        <<< TextAreaRow(tagDescription) {
            row in
            row.value = ""
        }
    }
    
    @IBAction func doneTapped() {
        
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
