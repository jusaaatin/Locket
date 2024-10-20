//
//  SettingsView.swift
//  Locket
//
//  Created by Justin Damhaut on 12/7/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var selfProfileDeleting: Bool
    @Binding var currentPage: locketPages
    let bindPerson: person?
    @State var isShowingAddSelf: Bool = false
    @Environment(\.dismiss) var dismiss
    
    private func dateToDM(input: Date) -> String {
        let DMFormatter = DateFormatter()
        DMFormatter.dateFormat = "d MMM"
        return DMFormatter.string(from: input)
    }
    private func returnAccentColor(isFgMatch: Bool, Hex: String) -> Color{
        if isFgMatch {
            return Color("Foreground-match")
        } else {
            return Color(hex: "\(Hex)") ?? Color("Foreground-match")
        }
    }
    
    var body: some View {
        if let selfPerson = bindPerson {
            NavigationView {
                ZStack {
            //      Color("Background-match").ignoresSafeArea()
                    ScrollView {
                        NavigationLink {
                            SelfProfileView(
                                deleting: $selfProfileDeleting,
                                currentPage: $currentPage,
                                bindPerson: selfPerson,
                                name: selfPerson.name,
                                birthday: selfPerson.birthday,
                                accentColor: returnAccentColor(
                                    isFgMatch: selfPerson.accentColorIsDefaultForeground,
                                    Hex: selfPerson.hexAccentColor),
                                demo: false,
                                mainImage: selfPerson.shownThumbnail,
                                slideImages: selfPerson.slideImages ?? [Data](),
                                socials: selfPerson.socials ?? [socials](),
                                description: selfPerson.personDescription,
                                creationDate: selfPerson.personModelCreationDate,
                                priority: selfPerson.priority
                            )
                            .navigationBarBackButtonHidden()
                            .ignoresSafeArea()
                        } label: {
                            SettingsViewProfileCard(name: selfPerson.name, birthday: selfPerson.birthday, relationshipStatus: selfPerson.relationshipStatus, accentColor: returnAccentColor(
                                isFgMatch: selfPerson.accentColorIsDefaultForeground,
                                Hex: selfPerson.hexAccentColor), shownThumbnail: selfPerson.shownThumbnail, bindPerson: bindPerson ?? person())
                            .padding()
                        }
                        Image(systemName: "figure.dance")
                            .font(.system(size: 60, weight: .semibold, design: .rounded))
                            .foregroundStyle(.gray.opacity(0.5))
                            .padding()
                            .padding(.bottom, 30)
                        Spacer()
                        // stuff here
                    }
                    .navigationBarTitle("Settings")
                }
            }
        } else {
            NavigationView {
                ScrollView {
                    Button(action: {
                        isShowingAddSelf = true
                    }, label: {
                        SettingsViewNilProfileCard().padding()
                    })
                    .sheet(isPresented: $isShowingAddSelf) {
                        AddSelfProfileView(debugOn: false)
                    }
                    Image(systemName: "figure.dance")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                        .foregroundStyle(.gray.opacity(0.5))
                        .padding()
                        .padding(.bottom, 30)
                }
                .navigationTitle("Settings")
            }
        }
    }
}

#Preview {
    @Previewable @State var selfProfileDeleting = false
    @Previewable @State var locketPages: locketPages = .home
    SettingsView(selfProfileDeleting: $selfProfileDeleting, currentPage: $locketPages, bindPerson: person(personUUID: UUID(), priority: 0, personid: 1000000, personModelCreationDate: .now, name: "Name", birthday: addOrSubtractYear(year: -15), hexAccentColor: "FFFFFF", accentColorIsDefaultForeground: true, shownThumbnail: Data(), slideImages: [Data](), socials: [
        socials(socialPlatform: .PhoneNumber, stringPRE: "65", stringMAIN: "91234567"),
         socials(socialPlatform: .Instagram, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Discord, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Slack, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Telegram, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Youtube, stringPRE: "", stringMAIN: "Username")
    ], relationshipStatus: .bestie, currentRelationshipStartDate: addOrSubtractYear(year: -3), personDescription: "Description"))
}

#Preview {
    @Previewable @State var selfProfileDeleting = false
    @Previewable @State var locketPages: locketPages = .home
    SettingsView(selfProfileDeleting: $selfProfileDeleting, currentPage: $locketPages, bindPerson: nil)
}
