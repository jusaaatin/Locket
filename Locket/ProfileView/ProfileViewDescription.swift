//
//  ProfileViewDescription.swift
//  Locket
//
//  Created by Justin Damhaut on 1/7/24.
//

import SwiftUI

struct ProfileViewDescription: View {
    
    let description: String
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text("")
                Spacer()
            }
            HStack {
                Text(description == "" ? "It's empty in here..." : description)
                    .foregroundStyle(description == "" ? .gray : Color("Foreground-match"))
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ProfileViewDescription(description: "fjhdhskjh")
}
