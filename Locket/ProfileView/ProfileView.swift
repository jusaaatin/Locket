//
//  ProfileView.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//


import SwiftUI



struct ProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var currentRSStatus: RelationshipStatus
    @Binding var deleting: Bool
    @Binding var currentPage: locketPages
    
    var bindPerson: person
    
    @State var updater: Int = 1
    
    @State var demoStartDate: Date
    @State var demoEndDate: Date
    @State var name: String
    @State var birthday: Date
    @State var instaUser: String
    @State var telPrefix: String
    @State var telNumber: String
    @State var accentColor: Color
    
    @State var demo: Bool
    @State var mainImage: Data
    @State var slideImages: [Data]
    
    @State var socials: [socials]


    @State var priority: Int
    
    private func returnAccentColor(isFgMatch: Bool, Hex: String) -> Color{
        if isFgMatch {
            return Color("Foreground-match")
        } else {
            return Color(hex: "\(Hex)") ?? Color("Foreground-match")
        }
    }
    

    
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                ScrollView {
                    ProfileViewHeader(currentRSStatus: currentRSStatus, name: name, accentColor: accentColor, demo: demo, mainImage: mainImage, slideImages: slideImages, birthday: birthday)
                        .onDisappear() {
                            withAnimation(.snappy) { currentPage = .home }
                        }
                        .id(updater)
                        .onAppear {
                            withAnimation(.snappy) { currentPage = .profile }
                            print("appeared")
                            
                            currentRSStatus = bindPerson.relationshipStatus
                            demoStartDate = bindPerson.currentRelationshipStartDate
                            name = bindPerson.name
                            birthday = bindPerson.birthday
                            accentColor = returnAccentColor(
                                isFgMatch: bindPerson.accentColorIsDefaultForeground,
                                Hex: bindPerson.hexAccentColor)
                            mainImage = bindPerson.shownThumbnail
                            slideImages = bindPerson.slideImages ?? [Data]()
                            socials = bindPerson.socials ?? []
                            priority = bindPerson.priority
                            updater += 1
                            
                            if priority == -1 {
                                dismiss()
                            }
                        }
                    ProfileViewRelationship(startDate: demoStartDate, currentRSStatus: currentRSStatus)
                        .padding([.leading, .trailing, .bottom])
                        .padding(.top, -30)
                        .onAppear {
                            withAnimation(.snappy) { currentPage = .profile }
                        }
                        .id(updater)
                    HStack {
                        Text("        Socials")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.top, -44)
                            .padding(.bottom, -5)
                        Spacer()
                    }.padding(.top, 40)
                    ProfileViewSocials(socials: socials, demo: demo)
                        .id(updater)
                        .padding([.bottom, .leading, .trailing])
                        .padding(.top, -30)
                    Image(systemName: "figure.walk.motion")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                        .foregroundStyle(.gray.opacity(0.5))
                        .padding()
                        .padding(.bottom, 30)
                }.scrollIndicators(.hidden)
                HStack {
                    Button {
                        withAnimation(.snappy) { currentPage = .home }
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                        }
                        .padding([.leading, .trailing])
                        .foregroundStyle(.black)
                        .background {
                            Circle()
                                .fill(.white.mix(with:.gray, by: 0.2).opacity(0.6))
                                .frame(height: 32)
                        }
                    }
                    Spacer()
                    NavigationLink {
                        EditProfileView(debugOn: false, bindedPerson: bindPerson)
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Text("Edit").bold()
                        }
                        .padding([.leading, .trailing])
                        .foregroundStyle(.black)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.mix(with:.gray, by: 0.2).opacity(0.6))
                                .frame(height: 32)
                        }
                    }
                    .id(UUID())
                }.padding().offset(y: 45)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    @Previewable @State var editIsPresented = false
    @Previewable @State var deleting = false
    @Previewable @State var currentPage: locketPages = .profile
    ProfileView(currentRSStatus: .crush, deleting: $deleting,
                currentPage: $currentPage, 
                bindPerson: person(),
                demoStartDate: addOrSubtractYear(year: -5),
                demoEndDate: addOrSubtractYear(year: -1),
                name: "Brain",
                birthday: addOrSubtractYear(year: -15),
                instaUser: "username",
                telPrefix: "123",
                telNumber: "91234567",
                accentColor: .white,
                demo: true,
                mainImage: Data(),
                slideImages: [Data](), socials:
                    [
                    socials(socialPlatform: .PhoneNumber, stringPRE: "65", stringMAIN: "91234567"),
                     socials(socialPlatform: .Instagram, stringPRE: "", stringMAIN: "Username"),
                    socials(socialPlatform: .Discord, stringPRE: "", stringMAIN: "Username"),
                    socials(socialPlatform: .Slack, stringPRE: "", stringMAIN: "Username"),
                    socials(socialPlatform: .Telegram, stringPRE: "", stringMAIN: "Username"),
                    socials(socialPlatform: .Youtube, stringPRE: "", stringMAIN: "Username")
                    ], priority: 0
    )
}
