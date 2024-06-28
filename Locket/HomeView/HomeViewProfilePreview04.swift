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
    let conditionalActivate: Bool
    let accentColor: Color
    let shownThumbnail: Data
    
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
                    if let uithumb = UIImage(data: thumb) {
                        Image(uiImage: uithumb)
                            .resizable()
                            .scaledToFill()
                            .frame(width:CGFloat(mainWidth), height: CGFloat(mainWidth))
                            .clipped()
                            .padding(.bottom, 5)
                    }
                    Text(name)
                        .padding(.top, -12)
                        .font(.system(size: 32, weight: .semibold, design: .serif))
                        .minimumScaleFactor(0.01)
                        //.italic()
                        .lineLimit(1)
                        .foregroundStyle(accentColor)
                        .frame(width:CGFloat(mainWidth))
                    HStack {
                        Image(systemName: "gift")
                        Text(dateToDM(input: birthday))
                    }
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.gray)
                    Spacer()
                }
                VStack {
                    HStack {
                        if conditionalActivate {
                            Image(systemName: "gift")
                                .font(.system(size: 16))
                                .padding(7)
                                .background(.thinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .padding(4)
                        }
                        Spacer()
                        Image(systemName: returnRightIconString())
                            .font(.system(size: CGFloat(returnRightIconSize())))
                            .padding(7)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding(4)
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
    HomeViewProfilePreview04(mainWidth: 169, mainImage: "demofood12", name: "Name", birthday: addOrSubtractYear(year: -15), relationshipStatus: .bestie, conditionalActivate: true, accentColor: .red, shownThumbnail: Data())
}


