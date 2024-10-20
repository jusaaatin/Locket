//
//  SettingsViewNilProfileCard.swift
//  Locket
//
//  Created by Justin Damhaut on 10/20/24.
//

import SwiftUI

struct SettingsViewNilProfileCard: View {
    var body: some View {
        HStack {
            Image("demofood12")
                .resizable()
                .scaledToFill()
                .frame(width:CGFloat(58), height: CGFloat(58))
                .clipShape(Circle())
                .clipped()
            HStack {
                VStack(alignment: .leading, spacing: -2) {
                    Text("Add yourself to locket!")
                        .font(.system(size: 22, weight: .semibold, design: .serif))
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .foregroundStyle(Color.white)
                        .frame(height: 39)
                    Group {
                        Text("Click to add self profile")
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.gray)
                        
                    } // birthday view
                }
                Spacer()
                VStack {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(.gray)
                }
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    SettingsViewNilProfileCard()
}
