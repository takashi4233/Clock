//
//  ClockApp.swift
//  Clock
//
//  Created by TAKASHI YOSHIMURA on 2023/01/05.
//

import SwiftUI

@main
struct ClockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
        }
    }
}
