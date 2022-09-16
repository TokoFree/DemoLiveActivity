//
//  MainView.swift
//  DemoLiveAct
//
//  Created by jefferson.setiawan on 02/08/22.
//

import SwiftUI

struct MainView: View {
    @State var isLiveActivityActive = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, world!")
                if #available(iOS 16.1, *) {
                    NavigationLink(destination: ContentView(), isActive: $isLiveActivityActive) {
                        Button("Go to Live activity demo page") {
                            self.isLiveActivityActive = true
                        }
                    }
                } else {
                    Text("You're on iOS < 16.1, can't use Live Activities!")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
