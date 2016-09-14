import Foundation

enum Color: String, CustomStringConvertible {
    case Red = "Red"
    case Orange = "Orange"
    case Yellow = "Yellow"
    case Green = "Green"
    case Blue = "Blue"
    case Purple = "Purple"
    case Cyan = "Cyan"
    case Gray = "Gray"
    
    var description: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static var colorHexStrings: [Color: String] = [
        .Gray: "7f7f7f",
        .Red: "ff0000",
        .Green: "00ff00",
        .Blue: "0000ff",
        .Yellow: "ffff00",
        .Purple: "9700ff",
        .Orange: "ff9300",
        .Cyan: "00ffff"
    ]
}