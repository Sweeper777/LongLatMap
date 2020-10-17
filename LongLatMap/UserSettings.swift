import Foundation

class UserSettings {
    static var mapType : MapType {
        get { UserDefaults.standard.string(forKey: tagMapType).flatMap(MapType.init) ?? .normal }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: tagMapType) }
    }
    
    static var flatMarkers : Bool {
        get { UserDefaults.standard.bool(forKey: tagFlatMarkers) }
        set { UserDefaults.standard.set(newValue, forKey: tagFlatMarkers) }
    }
    
    static var longLatStyle : LongLatFormatter.LongLatStyle {
        get { LongLatFormatter.LongLatStyle.init(rawValue: UserDefaults.standard.integer(forKey: tagLonglatStyle)) ?? .dms }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: tagLonglatStyle) }
    }
    
    static var showGraticules : Bool {
        get { UserDefaults.standard.bool(forKey: tagShowGraticules) }
        set { UserDefaults.standard.set(newValue, forKey: tagShowGraticules) }
    }
}
