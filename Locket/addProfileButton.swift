//
//  addProfileButton.swift
//  Locket
//
//  Created by Justin Damhaut on 14/6/24.
//

import SwiftUI

struct addProfileButton: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented = true
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 21.5)
                            .stroke(.quaternary, lineWidth: 3)
                    )
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
            }
        })
        .frame(width:60, height:60)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    addProfileButton(isPresented: $isPresented)
}
