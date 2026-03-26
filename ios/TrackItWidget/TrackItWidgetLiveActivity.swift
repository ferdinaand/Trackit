//
//  TrackItWidgetLiveActivity.swift
//  TrackItWidget
//
//  Created by DART GUY on 3/10/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TrackItWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TrackItWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrackItWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TrackItWidgetAttributes {
    fileprivate static var preview: TrackItWidgetAttributes {
        TrackItWidgetAttributes(name: "World")
    }
}

extension TrackItWidgetAttributes.ContentState {
    fileprivate static var smiley: TrackItWidgetAttributes.ContentState {
        TrackItWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TrackItWidgetAttributes.ContentState {
         TrackItWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TrackItWidgetAttributes.preview) {
   TrackItWidgetLiveActivity()
} contentStates: {
    TrackItWidgetAttributes.ContentState.smiley
    TrackItWidgetAttributes.ContentState.starEyes
}
