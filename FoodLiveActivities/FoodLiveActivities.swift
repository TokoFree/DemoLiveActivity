//
//  FoodLiveActivities.swift
//  FoodLiveActivities
//
//  Created by jefferson.setiawan on 02/08/22.
//

import WidgetKit
import SwiftUI

@main
struct MyFoodActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MyFoodAttributes.self) { context in
            MyFoodActivityView(model: MyFoodModel(
                numberOfItems: context.attributes.numberOfItems,
                totalAmount: context.attributes.totalAmount,
                progress: context.state.progress,
                estimatedDeliveryTime: context.state.estimatedDeliveryTime,
                status: context.state.process
            ))
        } dynamicIsland: { context in
            DynamicIsland {
                // Create the expanded view.
                DynamicIslandExpandedRegion(.leading) {
                    Text("F Leading")
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Label {
                        Text("F Trailing")
                    } icon: {
                        Image(systemName: "timer")
                            .foregroundColor(.indigo)
                    }
                    .font(.title2)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("CENTER")
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Button {
                        // Deep link into your app.
                    } label: {
                        Label("Call driver", systemImage: "phone")
                    }
                    .foregroundColor(.indigo)
                }
            } compactLeading: {
                Text("Leading")
            } compactTrailing: {
                Text("Trailing")
            } minimal: {
                Text("Min")
            }
        }
    }
}

struct MyFoodModel {
    var numberOfItems: Int
    var totalAmount: String
    var progress: Float
    var estimatedDeliveryTime: Date
    var status: String
}

@available(iOS 16.0, *)
struct MyFoodActivityView: View {
    let model: MyFoodModel
    var body: some View {
        VStack {
            HStack {
                Text("Total Items: \(model.numberOfItems)")
                Text("Rp \(model.totalAmount)")
            }
            Text("Status: \(model.status)")
            ProgressView(value: model.progress, total: 1)
                .transition(.move(edge: .trailing))
            Text(model.estimatedDeliveryTime, style: .timer)
        }
        .padding()
    }
}


struct FoodLiveActivities_Previews: PreviewProvider {
    static var previews: some View {
        MyFoodActivityView(model: MyFoodModel(numberOfItems: 2, totalAmount: "2", progress: 0.1, estimatedDeliveryTime: Date(timeIntervalSinceNow: 1_000), status: "Dummy status"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
