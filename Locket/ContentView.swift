//
//  ContentView.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State public var page: locketPages = .home

    @Environment(\.modelContext) var modelContext
    
    
    
    var body: some View {
        ZStack {
            HomeView(searchString: "", currentPage: $page)
        }
    }
}

#Preview {
    ContentView()
}
