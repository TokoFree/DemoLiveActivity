//
//  ContentView.swift
//  DemoLiveAct
//
//  Created by jefferson.setiawan on 29/07/22.
//

import ActivityKit
import SwiftUI


@available(iOS 16.0, *)
struct ContentView: View {
    let activity = MyActivity()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("Start Live Activities") {
                activity.request()
            }
            
            Button("Update Live Activities") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Task {
                        await activity.update()
                    }
                }
            }
            Button("End") {
                Task {
                    await activity.end()
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

@available(iOS 16.0, *)
class MyActivity {
    private let activityInfo = ActivityAuthorizationInfo()
    private var deliveryActivity: Activity<MyFoodAttributes>?
    var progress: Float = 0
    init() {}
    
    func request() {
        guard activityInfo.areActivitiesEnabled else {
            print("It's not allowed")
            return
        }
        
        let attr = MyFoodAttributes(numberOfItems: 10, totalAmount: "350000")
        let initial = MyFoodAttributes.ContentState(process: "Menunggu Driver", estimatedDeliveryTime: Date(timeIntervalSinceNow: 4200), progress: progress)
        
        do {
            let activity = try Activity<MyFoodAttributes>.request(
                attributes: attr,
                contentState: initial,
                pushType: nil
            )
            print("<<< pushToken: \(activity.pushToken)")
            deliveryActivity = activity
        } catch {
            print("<<< ERROR: ", error)
        }
    }
    
    func update() async {
        if progress < 1 {
            progress += 0.1
        }
        
        let updatedDeliveryStatus = MyFoodAttributes.ContentState(process: "Your food is being cooked.", estimatedDeliveryTime: Date().addingTimeInterval(60 * 60), progress: progress)
        await deliveryActivity?.update(using: updatedDeliveryStatus)
    }
    
    func end() async {
        await deliveryActivity?.end(using: nil, dismissalPolicy: .immediate)
    }
}
