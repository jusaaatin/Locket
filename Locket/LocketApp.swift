//
//  LocketApp.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//

import SwiftUI
import SwiftData

@main
struct LocketApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [person.self/*, events.self*/])
    }
}
