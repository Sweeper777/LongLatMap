import Foundation

@objc protocol SettingsControllerDelegate {
    func settingsController(_ settingsController: SettingsController, mapTypeChangedTo value: String)
    
    func settingsController(_ settingsController: SettingsController, flatMarkerChangedTo value: Bool)
    
    func settingsController(_ settingsController: SettingsController, longLatStyleChangedTo value: Int)
}
