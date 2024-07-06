//
//  ProfileViewDebug.swift
//  Locket
//
//  Created by Justin Damhaut on 6/7/24.
//

import SwiftUI

struct ProfileViewDebug: View {
    
    var bindPerson: person
    
    @State var updater: Int
    
    @State var demoStartDate: Date
    @State var name: String
    @State var birthday: Date
    @State var accentColor: Color
    @State var mainImage: Data
    @State var slideImages: [Data]
    @State var socials: [socials]
    @State var description: String
    @State var priority: Int
    @State var currentRSStatus: RelationshipStatus
    
    @State var modelDemoStartDate: Date
    @State var modelName: String
    @State var modelBirthday: Date
    @State var modelHexAccentColor: String
    @State var modelMainImage: Data
    @State var modelSlideImages: [Data]
    @State var modelSocials: [socials]
    @State var modelDescription: String
    @State var modelPriority: Int
    @State var modelCurrentRSStatus: RelationshipStatus
    @State var isPinned: Bool
    @State var isBirthdayToday: Bool
    @State var isAnniversaryToday: Bool
    @State var isBirthdayTomorrow: Bool
    @State var isAnniversaryTomorrow: Bool
    @State var isSelf: Bool
    @State var UUID: UUID
    @State var personID: Int
    @State var accentIsDefaultFg: Bool
    
    @State var viewExpanded = false
    
    var body: some View {
        VStack(spacing: 5) {
            if viewExpanded {
                Text("View")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                HStack {
                    Text("Updater:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(updater)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Name:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(name)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Birthday:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(birthday)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("AccentColor:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(accentColor)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("mainImage:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(mainImage)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("slideImages count:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(slideImages.count)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Socials count:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(socials.count)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Anniversary:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(demoStartDate)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Relationship status:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(currentRSStatus)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Description:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(description)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Priority:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(priority)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                
                //model
                Text("Model")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                HStack {
                    Text("UUID:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(UUID)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("personID:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(personID)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Name:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelName)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Birthday:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelBirthday)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("HexAccentColor:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelHexAccentColor)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("accentIsDefaultForeground:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(accentIsDefaultFg)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("mainImage:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelMainImage)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("slideImages count:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelSlideImages.count)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Socials count:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelSocials.count)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Anniversary:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelDemoStartDate)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Relationship status:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelCurrentRSStatus)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Description:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelDescription)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("Priority:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(modelPriority)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("isPinned:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(isPinned)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("isBirthdayToday:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(isBirthdayToday)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("isAnniversaryToday:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(isAnniversaryToday)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("isBirthdayTomorrow:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(isBirthdayTomorrow)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("isAnniversaryTomorrow:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(isAnniversaryTomorrow)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text("isSelf:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text("\(isSelf)")
                        .lineLimit(1)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                    Button(action: {
                        withAnimation(.interpolatingSpring) {
                            viewExpanded.toggle()
                        }
                    }, label: {
                        ZStack {
                            MeshGradient(
                                width: 3,
                                height: 3,
                                points: [
                                [0.0, 0.0], [0.5, 0], [1.0, 0.0],
                                [0.0, 0.5], [0.7, 0.5], [1.0, 0.5],
                                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                            ], colors: [
                                .red, .red.mix(with: .purple, by: 0.5), .red.mix(with: .purple, by: 0.8),
                                .red.mix(with: .purple, by: 0.8), .purple.mix(with: .blue, by: 0.4), .indigo,
                                .indigo.mix(with: .red, by: 0.5), .blue.mix(with: .purple, by: 0.6), .indigo.mix(with: .blue, by: 0.8)
                            ],
                                         
                                smoothsColors: true,
                                colorSpace: .perceptual
                            ).opacity(0.8)
                                .frame(width:48, height: 35)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .blur(radius: 4)
                            Image(systemName: "chevron.up")
                                .rotationEffect(.degrees(viewExpanded ? 0 : 180))
                                .foregroundStyle(.white).opacity(0.6)
                                .font(.system(size: 22))
                        }
                        .frame(width:48, height: 35)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.thickMaterial.opacity(0.8), lineWidth: 3)
                        )
                    }).padding(.leading, 10)
                }
     
            }
            else {
                HStack {
                    Spacer()
                    Text("Debug")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Button(action: {
                        withAnimation(.interpolatingSpring) {
                            viewExpanded.toggle()
                        }
                    }, label: {
                        ZStack {
                            MeshGradient(
                                width: 3,
                                height: 3,
                                points: [
                                [0.0, 0.0], [0.5, 0], [1.0, 0.0],
                                [0.0, 0.5], [0.7, 0.5], [1.0, 0.5],
                                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                            ], colors: [
                                .red, .red.mix(with: .purple, by: 0.5), .red.mix(with: .purple, by: 0.8),
                                .red.mix(with: .purple, by: 0.8), .purple.mix(with: .blue, by: 0.4), .indigo,
                                .indigo.mix(with: .red, by: 0.5), .blue.mix(with: .purple, by: 0.6), .indigo.mix(with: .blue, by: 0.8)
                            ],
                                         
                                smoothsColors: true,
                                colorSpace: .perceptual
                            ).opacity(0.8)
                                .frame(width:48, height: 35)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .blur(radius: 4)
                            Image(systemName: "chevron.up")
                                .rotationEffect(.degrees(viewExpanded ? 0 : 180))
                                .foregroundStyle(.white).opacity(0.6)
                                .font(.system(size: 22))
                        }
                        .frame(width:48, height: 35)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.thickMaterial.opacity(0.8), lineWidth: 3)
                        )
                    }).padding(.leading, 10)
                    Spacer()
                }
            }

        }
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ProfileViewDebug(bindPerson: person(), updater: 1, demoStartDate: .now, name: "name", birthday: .now, accentColor: Color.blue, mainImage: Data(), slideImages: [Data](), socials: [socials](), description: "description", priority: 1, currentRSStatus: .bestie, modelDemoStartDate: .now, modelName: "modelName", modelBirthday: .now, modelHexAccentColor: "FFFFFF", modelMainImage: Data(), modelSlideImages: [Data](), modelSocials: [socials](), modelDescription: "modelDescription", modelPriority: 1, modelCurrentRSStatus: .bestie, isPinned: false, isBirthdayToday: false, isAnniversaryToday: false, isBirthdayTomorrow: false, isAnniversaryTomorrow: false, isSelf: false, UUID: UUID(), personID: 1, accentIsDefaultFg: true).padding()
}
