//
//  SettingsViewProfileCard.swift
//  Locket
//
//  Created by Justin Damhaut on 10/18/24.
//

import SwiftUI

struct SettingsViewProfileCard: View {
    

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
    private func returnRightIconColor() -> Color {
        switch relationshipStatus {
        case .crush:
            return Color.pink
        case .relationship:
            return Color.red
        case .friend:
            return Color.cyan
        case .bestie:
            return Color.mint
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
    private func returnAccentColor(isFgMatch: Bool, Hex: String) -> Color{
        if isFgMatch {
            return Color("Foreground-match")
        } else {
            return Color(hex: "\(Hex)") ?? Color("Foreground-match")
        }
    }
    
    var body: some View {
        HStack {
            let thumb = shownThumbnail
            if thumb == Data() {
                Image("demofood12")
                    .resizable()
                    .scaledToFill()
                    .frame(width:CGFloat(80), height: CGFloat(80))
                    .clipShape(Circle())
                    .clipped()
            } else {
                let decompressedThumb = (thumb.decompress(withAlgorithm: .lzfse) ?? Data()) as Data
                if let uithumb = UIImage(data: decompressedThumb) {
                    Image(uiImage: uithumb)
                        .resizable()
                        .scaledToFill()
                        .frame(width:CGFloat(80), height: CGFloat(80))
                        .clipShape(Circle())
                        .clipped()
                }
            }
            VStack {
                HStack {
                    Text(name)
                        .font(.system(size: 32, weight: .semibold, design: .serif))
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .foregroundStyle(accentColor)
                        .frame(height: 39)
                    if bindPerson.isBirthdayToday() || bindPerson.isBirthdayTomorrow(){
                        HStack {
                            Image(systemName: "gift")
                                .frame(height: 12)
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
                                .frame(height: 12)
                            Text(dateToDM(input: birthday))
                        }
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                HStack {
                    Text("Click to more")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    SettingsViewProfileCard(name: "Justin", birthday: addOrSubtractYear(year: -15), relationshipStatus: .relationship, accentColor: .blue, shownThumbnail: Data(), bindPerson: person(personUUID: UUID(), priority: 0, personid: 1000000, personModelCreationDate: .now, name: "Name", birthday: addOrSubtractYear(year: -15), hexAccentColor: "FFFFFF", accentColorIsDefaultForeground: true, shownThumbnail: Data(), slideImages: [Data](), socials: [
        socials(socialPlatform: .PhoneNumber, stringPRE: "65", stringMAIN: "91234567"),
         socials(socialPlatform: .Instagram, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Discord, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Slack, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Telegram, stringPRE: "", stringMAIN: "Username"),
        socials(socialPlatform: .Youtube, stringPRE: "", stringMAIN: "Username")
    ], relationshipStatus: .bestie, currentRelationshipStartDate: addOrSubtractYear(year: -3), personDescription: "Description"))
}
