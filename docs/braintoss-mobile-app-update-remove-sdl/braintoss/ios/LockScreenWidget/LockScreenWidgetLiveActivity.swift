import ActivityKit
import WidgetKit
import SwiftUI

// Definišemo atribute aktivnosti
struct DefaultAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dodaj atribute za stanje aktivnosti ako je potrebno
    }
}

// Glavni Live Activity widget
struct LockScreenWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DefaultAttributes.self) { context in
            // Prikaz kada je aktivnost u toku
            VStack {
                Text("Live Activity in progress")
            }
            .activityBackgroundTint(Color.blue)
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                // Prikaz za različite regione u Dynamic Island-u
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading Content")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing Content")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom Content")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
        }
    }
}
