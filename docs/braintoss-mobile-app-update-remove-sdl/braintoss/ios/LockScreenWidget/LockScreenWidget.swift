import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct LockScreenWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entries = [SimpleEntry(date: Date())]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct LockScreenWidgetEntryView: View {
    var entry: SimpleEntry
    

    var body: some View {
        Link(destination: URL(string: "com.braintoss.braintoss://openApp")!) {
            VStack {
                Image("WidgetIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 96, height: 96)
            }
        }
        .containerBackground(for: .widget) {  // Adds background to the widget
            Color.yellow  // You can set any background color if needed
        }
    }
}

struct LockScreenWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))  // Koristi odgovarajuću veličinu
    }
}
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LockScreenWidgetProvider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Braintoss")
        .description("A quick-launch widget for the Braintoss app, providing fast and easy access directly from the Lock Screen or Home Screen.")
        .supportedFamilies([.systemSmall,.systemMedium, .systemLarge,.accessoryCircular, .accessoryRectangular])
    }
}

