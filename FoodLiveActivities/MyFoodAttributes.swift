//
//  MyFoodAttributes.swift
//  DemoLiveAct
//
//  Created by jefferson.setiawan on 02/08/22.
//

import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.0, *)
struct MyFoodAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var process: String
        var estimatedDeliveryTime: Date
        var progress: Float = 0
    }

    var numberOfItems: Int
    var totalAmount: String
}
