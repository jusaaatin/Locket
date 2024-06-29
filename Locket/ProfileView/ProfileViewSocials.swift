//
//  ProfileViewSocials.swift
//  Locket
//
//  Created by Justin Damhaut on 29/6/24.
//

import SwiftUI

struct ProfileViewSocials: View {
    
    var socials: [socials]
    var demo: Bool
    
    var body: some View {
        ForEach(socials) { social in
            HStack {
                Image(social.socialPlatform.rawValue.lowercased())
                Text("\(social.socialPlatform.rawValue): ")
                if social.socialPlatform == .PhoneNumber {
                    Text("+\(social.stringPRE) ") +
                    Text("\(social.stringMAIN)")
                } else {
                    Text("\(social.stringMAIN)")
                }
            }
        }
    }
}

#Preview {
    ProfileViewSocials(socials: [socials(socialPlatform: .PhoneNumber, stringPRE: "65", stringMAIN: "91234567")/*, socials(socialPlatform: .Instagram, stringPRE: "", stringMAIN: "instagram")*/], demo: true)
}
