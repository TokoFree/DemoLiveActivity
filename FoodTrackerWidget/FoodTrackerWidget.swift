//
//  FoodTrackerWidget.swift
//  FoodTrackerWidget
//
//  Created by jefferson.setiawan on 29/07/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), type: .placeholder)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, type: .snapshot)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for secondOffset in 0 ..< 5 {
            let type: MyType
            if secondOffset == 0 {
                type = .nonLoggedIn
            } else if secondOffset == 1 {
                type = .snapshot
            } else if secondOffset == 2 {
                type = .placeholder
            } else if secondOffset == 3 {
                type = .nonLoggedIn
            } else {
                type = .content
            }
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset * 15, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, type: type)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(timeline)
        }
    }
}

enum MyType {
    case placeholder
    case snapshot
    case content
    case nonLoggedIn
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let type: MyType
}

struct FoodTrackerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch entry.type {
        case .nonLoggedIn:
            HStack {
                Text("Login")
                    .privacySensitive()
                Image(systemName: "timer")
                    .foregroundColor(.indigo)
            }
        case .snapshot:
            VStack {
                Text("SNAPSHOT??")
                Text("LAGI")
            }
        case .placeholder:
            VStack {
                Text("Placeholder")
            }
            .widgetAccentable()
        case .content:
            ZStack {
                AccessoryWidgetBackground()
                VStack {
                    HStack {
                        Text("Place")
                            .redacted(reason: .placeholder)
                        Text("privacy")
                            .redacted(reason: .privacy)
                    }
                    HStack {
                        Text("Unredact")
                            .unredacted()
                        Text("Normal 2")
                            .privacySensitive(true)
                    }
                }
            }
            .cornerRadius(4)
            .widgetAccentable()
        }
    }
}

struct FoodTrackerWidget: Widget {
    let kind: String = "FoodTrackerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FoodTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryRectangular])
    }
}

@main
internal struct WidgetMainView: WidgetBundle {
    @WidgetBundleBuilder
    internal var body: some Widget {
        FoodTrackerWidget()
    }
}
