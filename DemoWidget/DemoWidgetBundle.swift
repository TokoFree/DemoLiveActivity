//
//  DemoWidgetBundle.swift
//  DemoWidget
//
//  Created by Jefferson Setiawan on 15/09/24.
//

import WidgetKit
import SwiftUI

@main
struct DemoWidgetBundle: WidgetBundle {
    var body: some Widget {
        DemoWidget()
        DemoWidgetLiveActivity()
        if #available(iOSApplicationExtension 18, *) {
            DemoControl()
        }
    }
}
