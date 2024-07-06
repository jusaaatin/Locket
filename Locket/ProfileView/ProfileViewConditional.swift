//
//  ProfileViewConditional.swift
//  Locket
//
//  Created by Justin Damhaut on 6/7/24.
//

import SwiftUI

struct ProfileViewConditional: View {
    var body: some View {
        HStack {
            Image(systemName: "gift")
            VStack {
                Text("It's Justin's birthday today!")
            }
        }
    }
}

#Preview {
    ProfileViewConditional()
}
