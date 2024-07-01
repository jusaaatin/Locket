//
//  ProfileViewDescription.swift
//  Locket
//
//  Created by Justin Damhaut on 1/7/24.
//

import SwiftUI

struct ProfileViewDescription: View {
    
    @State var description: String
    
    var body: some View {
        HStack {
            Text(description)
        }
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ProfileViewDescription(description: "Description 1 hdjgksh hfdkjla  kdlsjhl fashjkl jfksadh jklhdsfk adfskjh kjadfsh kldfsh kjfsadh lkjdfsah kljdfhas kjdfsah kjfdsh lkjdfah lkjhdfsa lkjhdaf lkjh kjlhsdaf").padding()
}
