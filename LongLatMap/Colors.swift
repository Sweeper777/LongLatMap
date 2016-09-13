import Foundation

enum Color: String, CustomStringConvertible {
    case Red = "Red"
    case Orange = "Orange"
    case Yellow = "Yellow"
    case Green = "Green"
    case Blue = "Blue"
    case Purple = "Purple"
    case Black = "Black"
    case Gray = "Gray"
    case White = "White"
    
    var description: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}