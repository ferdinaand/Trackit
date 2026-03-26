//
//  TrackItWidget.swift
//  TrackItWidget
//
//  Created by DART GUY on 3/10/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    private func getDataFromFlutter() -> SimpleEntry {
        let userDefaults = UserDefaults(suiteName: "group.TrackitMobileApp")
        let textFromFlutterApp = userDefaults?.string(forKey: "text_from_flutter_app") ?? "10"
        
        // Create a ConfigurationAppIntent with the retrieved value
        let config = ConfigurationAppIntent()
        config.text = textFromFlutterApp
        
        return SimpleEntry(date: Date(), configuration: config)
    }
    
    
    //preview in widget galler
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    //widget gallery preview/selection
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        getDataFromFlutter()
    }
    
    
    //actual widget on homescreen
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        let entry = getDataFromFlutter()  // Fetch the data from UserDefaults
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
//this represents the data structure for our widgets
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}



//the view that defines how our widget looks
struct TrackItWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Income: \(entry.configuration.text)")
        }
    }
}




//the main widget configuration
struct TrackItWidget: Widget {
    let kind: String = "TrackItWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TrackItWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.text = "0"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.text = "0"
        return intent
    }
}

#Preview(as: .systemSmall) {
    TrackItWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
