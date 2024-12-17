//
//  ContentView.swift
//  DemoLiveAct
//
//  Created by jefferson.setiawan on 29/07/22.
//

import ActivityKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Your Token: \(viewModel.token ?? "none")")
            Text("State: \(viewModel.stateUpdate.debugDescription)")
            Button("Copy Token to clipboard") {
                viewModel.copyTokenToClipboard()
            }
            Button("Start Live Activities") {
                viewModel.startNewLA()
            }
            
            if #available(iOS 17.0, *) {
                Button(intent: LAIntent()) {
                    Text("Start via Intent")
                }
            }
            
            Button("Update Live Activities") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Task {
                        await viewModel.update()
                    }
                }
            }
            Button("End Live Activities") {
                Task {
                    await viewModel.end()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
import CoreLocation

@MainActor
class ViewModel: NSObject, ObservableObject {
    @Published private(set) var token: String?
    @Published private(set) var stateUpdate: MyFoodAttributes.ContentState?
    
    private let activityInfo = ActivityAuthorizationInfo()
    private var deliveryActivity: Activity<MyFoodAttributes>?
    var progress: Float = 0
    override init() {}
    
    func startNewLA() {
        guard activityInfo.areActivitiesEnabled else {
            print("It's not allowed")
            return
        }
        AppDelegate.instance.laManager.requestLocationAccessIfNeeded()
        // check for location access.
        
        let attr = MyFoodAttributes(numberOfItems: 10, totalAmount: "350000")
        let initial = MyFoodAttributes.ContentState(process: "Menunggu Driver", estimatedDeliveryTime: Date(timeIntervalSinceNow: 2*60*60), progress: progress)
        
        do {
            let activity = try Activity<MyFoodAttributes>.request(
                attributes: attr,
                content: ActivityContent(state: initial, staleDate: Date(timeIntervalSinceNow: 2*60*60)),
                pushType: nil
            )
            deliveryActivity = activity
        } catch {
            print("<<< ERROR: ", error)
        }
    }
    
//    func registerToken(activity: Activity<MyFoodAttributes>) {
//        Task {
//            for await data in activity.pushTokenUpdates {
//                let token = data.map { String(format: "%02x", $0) }.joined()
//                self.token = token
//            }
//        }
//        
//        Task {
//            for await stateUpdate in activity.contentStateUpdates {
//                self.stateUpdate = stateUpdate
//            }
//        }
//    }
    
    func update() async {
        if progress < 1 {
            progress += 0.1
        }
        
        let updatedDeliveryStatus = MyFoodAttributes.ContentState(process: "Your food is being cooked.", estimatedDeliveryTime: Date().addingTimeInterval(60 * 60), progress: progress)
        await deliveryActivity?.update(ActivityContent(state: updatedDeliveryStatus, staleDate: nil))
    }
    
    func end() async {
        await deliveryActivity?.end(nil)
    }
    
    func copyTokenToClipboard() {
        UIPasteboard.general.string = token
    }
}
