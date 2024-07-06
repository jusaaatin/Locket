//
//  HomeViewProfilePreview04.swift
//  Locket
//
//  Created by Justin Damhaut on 12/6/24.
//

import SwiftUI

struct HomeViewProfilePreview04: View {
    
    let mainWidth: Int
    
    let mainImage: String
    let name: String
    let birthday: Date
    let relationshipStatus: RelationshipStatus
    let accentColor: Color
    let shownThumbnail: Data
    
    let bindPerson: person
    
    private func dateToDM(input: Date) -> String {
        let DMFormatter = DateFormatter()
        DMFormatter.dateFormat = "d MMM"
        return DMFormatter.string(from: input)
    }
    
    private func returnRightIconString() -> String {
        switch relationshipStatus {
        case .crush:
            return "heart"
        case .relationship:
            return "heart.fill"
        case .bestie:
            return "figure.2"
        case .friend:
            return "person.2"
        }
    }
    
    private func returnRightIconSize() -> Int {
        switch relationshipStatus {
        case .crush:
            return 16
        case .relationship:
            return 16
        case .bestie:
            return 13
        case .friend:
            return 13
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    let thumb = shownThumbnail
                    if thumb == Data() {
                        Image("demofood12")
                            .resizable()
                            .scaledToFill()
                            .frame(width:CGFloat(mainWidth), height: CGFloat(mainWidth))
                            .clipped()
                            .padding(.bottom, -11)
                    } else {
                        if let uithumb = UIImage(data: thumb) {
                            Image(uiImage: uithumb)
                                .resizable()
                                .scaledToFill()
                                .frame(width:CGFloat(mainWidth), height: CGFloat(mainWidth))
                                .clipped()
                                .padding(.bottom, -11)
                    }

                    }
                    Text(name)
                        .offset(y: 4)
                        .padding([.leading, .trailing])
                        .font(.system(size: 32, weight: .semibold, design: .serif))
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .foregroundStyle(accentColor)
                        .frame(width:CGFloat(mainWidth))
                        .frame(height: 39)
                    if bindPerson.isBirthdayToday() || bindPerson.isBirthdayTomorrow(){
                        HStack {
                            Image(systemName: "gift")
                            Text(bindPerson.isBirthdayToday() ? "Today" : "Tomorrow")
                        }
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.red.mix(with: .white, by: 0.3))
                    } else if bindPerson.isAnniversaryToday() || bindPerson.isAnniversaryTomorrow(){
                        HStack {
                            Text("Anniversary").padding(.leading, -5)
                            Text(bindPerson.isAnniversaryToday() ? "Today" : "Tomorrow").padding(.trailing, -5)
                        }
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.red.mix(with: .white, by: 0.3))
                    } else {
                        HStack {
                            Image(systemName: "gift")
                            Text(dateToDM(input: birthday))
                        }
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                VStack {
                    HStack {
                        if bindPerson.isPinned() || bindPerson.isBirthdayToday() || bindPerson.isAnniversaryToday() || bindPerson.isBirthdayTomorrow() || bindPerson.isAnniversaryTomorrow() {
                            Group {
                                if bindPerson.isBirthdayToday() || bindPerson.isBirthdayTomorrow(){
                                    Image(systemName: "gift")
                                        .font(.system(size: 16))
                                } else if bindPerson.isAnniversaryToday() || bindPerson.isAnniversaryTomorrow(){
                                    Image(systemName: "party.popper.fill")
                                        .font(.system(size: 12))
                                } else if bindPerson.isPinned() {
                                    Image(systemName: "pin.fill")
                                        .font(.system(size: 14))
                                }
                            }
                                
                                .padding(7)
                                .background(.thinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .padding(4)
                                .offset(x:bindPerson.isPinned() ? 2.5 : 1.5, y:2.5)
                        }
                        Spacer()
                        Image(systemName: returnRightIconString())
                            .font(.system(size: CGFloat(returnRightIconSize())))
                            .padding(7)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding(4)
                            .offset(y:1.5)
                    }
                    Spacer()
                }
                
            }
        }
        .frame(width:CGFloat(mainWidth), height:CGFloat(218*mainWidth/160))
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HomeViewProfilePreview04(mainWidth: 169, mainImage: "demofood12", name: "Name", birthday: addOrSubtractMonth(month: -2), relationshipStatus: .bestie, accentColor: Color(hex: "B18CFE") ?? Color.blue, shownThumbnail: Data(), bindPerson: person(personUUID: UUID(), priority: 1, personid: 1000000, personModelCreationDate: .now, name: "Name", birthday: addOrSubtractMonth(month: -0), hexAccentColor: "FF8C82", accentColorIsDefaultForeground: true, shownThumbnail: Data(), slideImages: [Data](), socials: [
        socials(socialPlatform: .PhoneNumber, stringPRE: "65", stringMAIN: "91234567"),
         socials(socialPlatform: .Instagram, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Discord, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Slack, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Telegram, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Youtube, stringPRE: "", stringMAIN: "Username")
    ], relationshipStatus: .bestie, currentRelationshipStartDate: addOrSubtractDay(day: 5), personDescription: "Description"))
}


