//
//  AddProfileViewNotes.swift
//  Locket
//
//  Created by Justin Damhaut on 27/6/24.
//

import SwiftUI

struct AddProfileViewNotes: View {
    
    @Binding var description: String
    
    var body: some View {
        Group {
            TextField("Notes", text: $description, axis: .vertical)
                .padding()
                .background(Color.gray.mix(with:Color("Background-match"), by: 0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    @Previewable @State var description = ""
    AddProfileViewNotes(description: $description)
}
