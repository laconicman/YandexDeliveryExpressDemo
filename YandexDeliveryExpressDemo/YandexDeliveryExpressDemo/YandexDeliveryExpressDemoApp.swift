//
//  YandexDeliveryExpressDemoApp.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/15/25.
//

import SwiftUI
/* import SwiftData

@main
struct YandexDeliveryExpressDemoApp: App {
    @StateObject private var state = DemoState()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Claim.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // ContentView()
            PhaseNavigationView()
                .environmentObject(state)
        }
        .modelContainer(sharedModelContainer)
    }
}
*/

// Sources/ExpressDemo/ExpressDemoApp.swift
import SwiftUI

@main
struct ExpressDemoApp: App {
    @StateObject private var state = RequestState()

    var body: some Scene {
        WindowGroup {
            PhaseNavigationView()
                .environmentObject(state)
        }
    }
}
