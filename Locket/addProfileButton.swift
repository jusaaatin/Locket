//
//  addProfileButton.swift
//  Locket
//
//  Created by Justin Damhaut on 14/6/24.
//

import SwiftUI

struct addProfileButton: View {
    
    @Binding var currentPage: locketPages
    @Binding var isPresented: Bool
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Button(action: {
            if currentPage != .profile {
                isPresented = true
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 21.5)
                            .stroke(.quaternary, lineWidth: 3)
                    )
                Image(systemName: currentPage == .profile ? "pencil" : "plus")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
            }
        })
        .frame(width:60, height:60)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @State var currentPage: locketPages = .home
    @Previewable @State var isPresented: Bool = true
    addProfileButton(currentPage: $currentPage, isPresented: $isPresented)
}
