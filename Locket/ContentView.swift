//
//  ContentView.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var isPresented: Bool = false
    @State public var page: locketPages = .home

    @Environment(\.modelContext) var modelContext
    
    
    
    var body: some View {
        ZStack {
            HomeView(searchString: "", currentPage: $page)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    addProfileButton(currentPage: $page, isPresented: $isPresented)
                        .shadow(color: .black.opacity(0.5), radius: 8)
                        .padding()
                        .padding(.trailing, 1)
                        .sheet(isPresented: $isPresented) {
                            AddProfileView(debugOn: false).interactiveDismissDisabled()
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
