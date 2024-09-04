//
//  weather_home_screenLiveActivity.swift
//  weather_home_screen
//
//  Created by Trần Thị Yến Nhi on 18/7/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct weather_home_screenAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct weather_home_screenLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: weather_home_screenAttributes.self) { context in
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

extension weather_home_screenAttributes {
    fileprivate static var preview: weather_home_screenAttributes {
        weather_home_screenAttributes(name: "World")
    }
}

extension weather_home_screenAttributes.ContentState {
    fileprivate static var smiley: weather_home_screenAttributes.ContentState {
        weather_home_screenAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: weather_home_screenAttributes.ContentState {
         weather_home_screenAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: weather_home_screenAttributes.preview) {
   weather_home_screenLiveActivity()
} contentStates: {
    weather_home_screenAttributes.ContentState.smiley
    weather_home_screenAttributes.ContentState.starEyes
}
