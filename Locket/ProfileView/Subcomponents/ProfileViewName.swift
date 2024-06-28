//
//  ProfileViewHeader.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//

import SwiftUI

struct ProfileViewName: View {
    
    var name: String
    var accentColor: Color
    
    var demo: Bool
    var mainImage: Data
    var slideImages: [Data]
    
    var body: some View {
        ZStack {
            VStack {
                ProfileViewHeaderImage(demo: demo, mainImage: mainImage, slideImages: slideImages)
                    .frame(height:460)
                Rectangle()
                    .fill(.black)
                    .opacity(0)
                    .clipped()
                    .frame(height:30)
            }
            VStack {
                Rectangle()
                    .frame(height:360)
                    .opacity(0)
                Rectangle()
                    .frame(height: 90)
                    .foregroundStyle(
                        LinearGradient(gradient: Gradient(colors: [Color("Background-match").opacity(0), Color("Background-match").opacity(100)]), startPoint: .top, endPoint: .bottom))
                    
            }
            VStack {
                Rectangle()
                    .opacity(0)
                    .clipped()
                    .frame(height:300)
                Text(name)
                    .padding(.top, 32)
                    .font(.system(size: 85, weight: .semibold, design: .serif))
                    .minimumScaleFactor(0.01)
                    .padding([.leading, .trailing])
                 //   .italic()
                    .lineLimit(1)
                    .foregroundStyle(accentColor)
                    .shadow(color:.white, radius:40)
                    .shadow(color:.black, radius:20)
            }
        }
    }
}

#Preview {
    ProfileViewName(name: "Name", accentColor: .red, demo: true, mainImage: Data(), slideImages: [Data]())
}
