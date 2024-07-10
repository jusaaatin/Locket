//
//  AddProfileButton.swift
//  Locket
//
//  Created by Justin Damhaut on 14/6/24.
//

import SwiftUI

struct AddProfileButton: View {
    
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
                            .stroke(Color.gray.mix(with:Color("Background-match"), by: 0.6), lineWidth: 3)
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
    @Previewable @State var isPresented: Bool = false
    AddProfileButton(isPresented: $isPresented)
}
