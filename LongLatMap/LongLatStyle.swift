import Foundation

enum LongLatStyle: Int, CustomStringConvertible {
    case integer = 0
    case sigFig1, sigFig2, sigFig3, sigFig4, sigFig5, sigFig6, sigFig7, sigFig8, sigFig9
    
    var description: String {
        switch self {
        case .integer:
            return NSLocalizedString("Integer", comment: "")
        case .sigFig1:
            return "\(self.rawValue) \(NSLocalizedString("Decimal Place", comment: ""))"
        default:
            return "\(self.rawValue) \(NSLocalizedString("Decimal Places", comment: ""))"
        }
    }
}
