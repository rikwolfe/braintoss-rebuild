import Foundation


enum SiriShortcutType {
    case openNote
    case openVoice
    case openPhoto

    var siriActivityType: String {
        switch self {
            case .openNote:
            return "com.braintoss.braintoss.openNote"
            case .openVoice:
            return "com.braintoss.braintoss.openVoice"
            case .openPhoto:
            return "com.braintoss.braintoss.openPhoto"
        }
    }

    var siriShortcutTitle: String {
        switch self {
        case .openNote:
            return "Open Note page"
        case .openVoice:
            return "Open Voice page"
        case .openPhoto:
            return "Open Photo page"
        }
    }

    static let allCases:[SiriShortcutType] = [.openNote, .openVoice, .openPhoto]
}
