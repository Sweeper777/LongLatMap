import Foundation

enum Color: String, CustomStringConvertible {
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case blue = "Blue"
    case purple = "Purple"
    case cyan = "Cyan"
    case gray = "Gray"
    
    var description: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static var colorHexStrings: [Color: String] = [
        .gray: "7f7f7f",
        .red: "ff0000",
        .green: "00ff00",
        .blue: "0000ff",
        .yellow: "ffff00",
        .purple: "9700ff",
        .orange: "ff9300",
        .cyan: "00ffff"
    ]
}
