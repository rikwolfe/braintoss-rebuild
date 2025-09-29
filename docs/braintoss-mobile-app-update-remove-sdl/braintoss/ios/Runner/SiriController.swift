
import Foundation
import UIKit
import Intents
import Flutter


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

class SiriController: FlutterViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()   

        registerSiriShortcuts()
    }
    
    func registerSiriShortcuts() {
        let cases = SiriShortcutType.allCases
        var suggestions: [INShortcut] = []
        for type in cases {

            let activity = NSUserActivity(activityType: type.siriActivityType)

            activity.title = type.siriShortcutTitle

            activity.isEligibleForSearch = true
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(type.siriActivityType)
            activity.becomeCurrent()
            suggestions.append(INShortcut.init(userActivity: activity))
        }
        DispatchQueue.main.async {
            INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
        }
    }
}


