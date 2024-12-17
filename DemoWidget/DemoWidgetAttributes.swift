//
//  DemoWidgetAttributes.swift
//  DemoWidgetExtension
//
//  Created by Jefferson Setiawan on 15/09/24.
//

import ActivityKit

struct DemoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
