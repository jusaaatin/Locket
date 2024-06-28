//
//  RelationshipStatusPickerButton.swift
//  Locket
//
//  Created by Justin Damhaut on 17/6/24.
//

import SwiftUI

struct RelationshipStatusPickerButton: View {
    
    @Binding var selectedRelationshipStatus: RelationshipStatus
    let buttonRelationshipStatus: RelationshipStatus
    let accentColor: Color

    private func returnColor(element: Int) -> Color {
        //elements: Image 1, Text 2
        if element == 1 {
            if selectedRelationshipStatus == buttonRelationshipStatus {
                return .white
            } else {
                return .gray
            }
        } else {
            if selectedRelationshipStatus == buttonRelationshipStatus {
                return accentColor
            } else {
                return .gray
            }
        }
    }
    
    private func returnIconString() -> String {
        switch buttonRelationshipStatus {
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
    
    private func returnStatus() -> String {
        switch buttonRelationshipStatus {
        case .crush:
            return "Crush"
        case .relationship:
            return "Dating"
        case .bestie:
            return "Bestie"
        case .friend:
            return "Friend"
        }
    }
    
    private func returnIconSize() -> Int {
        switch buttonRelationshipStatus {
        case .crush:
            return 22
        case .relationship:
            return 22
        case .bestie:
            return 18
        case .friend:
            return 16
        }
    }
    
    
    var body: some View {
        
        let matching: Bool = selectedRelationshipStatus == buttonRelationshipStatus
        
        Button {
            if !matching {
                withAnimation(.bouncy){ selectedRelationshipStatus = buttonRelationshipStatus }
            }
        } label: {
            ZStack {
                if matching {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 120, height:42)
                        .foregroundStyle(accentColor)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 60, height:42)
                        .foregroundStyle(.thinMaterial)
                }
                HStack {
                    Image(systemName: returnIconString())
                        .font(.system(size: CGFloat(returnIconSize())))
                        .foregroundStyle(returnColor(element: 1))
                    if matching {
                        Text("\(returnStatus())")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .buttonStyle(PlainButtonStyle())
        .shadow(color: accentColor, radius: matching ? 5 : -20)
    }
    
}

#Preview {
    @Previewable @State var searchFilter: RelationshipStatus = .friend
    VStack {
        RelationshipStatusPickerButton(selectedRelationshipStatus: $searchFilter, buttonRelationshipStatus: .friend, accentColor: .pink)
        RelationshipStatusPickerButton(selectedRelationshipStatus: $searchFilter, buttonRelationshipStatus: .bestie, accentColor: .red)
        RelationshipStatusPickerButton(selectedRelationshipStatus: $searchFilter, buttonRelationshipStatus: .crush, accentColor: .blue)
        RelationshipStatusPickerButton(selectedRelationshipStatus: $searchFilter, buttonRelationshipStatus: .relationship, accentColor: .indigo)
    }
}
