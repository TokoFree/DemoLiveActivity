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
        ActivityConfiguration(attributesType: MyFoodAttributes.self) { context in
            MyFoodActivityView(model: MyFoodModel(
                numberOfItems: context.attributes.numberOfItems,
                totalAmount: context.attributes.totalAmount,
                progress: context.state.progress,
                estimatedDeliveryTime: context.state.estimatedDeliveryTime
            ))
        }
    }
}

struct MyFoodModel {
    var numberOfItems: Int
    var totalAmount: String
    var progress: Float
    var estimatedDeliveryTime: Date
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
            ProgressView(value: model.progress, total: 1)
            Text(model.estimatedDeliveryTime, style: .timer)
        }
        .padding()
    }
}


struct FoodLiveActivities_Previews: PreviewProvider {
    static var previews: some View {
        MyFoodActivityView(model: MyFoodModel(numberOfItems: 2, totalAmount: "2", progress: 0.1, estimatedDeliveryTime: Date(timeIntervalSinceNow: 1_000)))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
