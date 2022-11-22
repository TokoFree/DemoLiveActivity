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
@MainActor
class ViewModel: ObservableObject {
    @Published private(set) var token: String?
    @Published private(set) var stateUpdate: MyFoodAttributes.ContentState?
    
    private let activityInfo = ActivityAuthorizationInfo()
    private var deliveryActivity: Activity<MyFoodAttributes>?
    var progress: Float = 0
    init() {}
    
    func startNewLA() {
        guard activityInfo.areActivitiesEnabled else {
            print("It's not allowed")
            return
        }
        
        let attr = MyFoodAttributes(numberOfItems: 10, totalAmount: "350000")
        let initial = MyFoodAttributes.ContentState(process: "Menunggu Driver", estimatedDeliveryTime: Date(timeIntervalSinceNow: 2*60*60), progress: progress)
        
        do {
            let activity = try Activity<MyFoodAttributes>.request(
                attributes: attr,
                contentState: initial,
                pushType: .token
            )
            deliveryActivity = activity
            registerToken(activity: activity)
        } catch {
            print("<<< ERROR: ", error)
        }
    }
    
    func registerToken(activity: Activity<MyFoodAttributes>) {
        Task {
            for await data in activity.pushTokenUpdates {
                let token = data.map { String(format: "%02x", $0) }.joined()
                self.token = token
            }
        }
        
        Task {
            for await stateUpdate in activity.contentStateUpdates {
                self.stateUpdate = stateUpdate
            }
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
        await deliveryActivity?.end(using: nil)
    }
    
    func copyTokenToClipboard() {
        UIPasteboard.general.string = token
    }
}
