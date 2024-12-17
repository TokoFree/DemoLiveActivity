//
//  LAIntent.swift
//  DemoWidgetExtension
//
//  Created by Jefferson Setiawan on 15/09/24.
//

import AppIntents
import ActivityKit

struct LAIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Start LA"
    
    func perform() async throws -> some IntentResult {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return .result()
        }
        do {
            let activity = try Activity.request(
                attributes: DemoWidgetAttributes(name: "tests"),
                content: .init(
                    state: DemoWidgetAttributes.ContentState(emoji: "😂"),
                    staleDate: Date().addingTimeInterval(60*60)
                )
            )
            UIImage().preparingForDisplay()
            #if MAIN_APP
            await AppDelegate.instance.laManager.requestLocationAccessIfNeeded()
            #endif
            // check if the user is in the app, if yes, check if the user has location access, if no, open the app to trigger location permission.
            // ask AppDelegate to start LALocationManager and start listening.
        } catch {
            print(error)
        }
        
        return .result()
    }
    
}

@available(iOSApplicationExtension, unavailable)
extension LAIntent: ForegroundContinuableIntent {}
