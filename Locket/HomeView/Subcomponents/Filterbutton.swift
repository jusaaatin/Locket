//
//  Filterbutton.swift
//  Locket
//
//  Created by Justin Damhaut on 13/6/24.
//

import SwiftUI


struct Filterbutton: View {
    
    @Binding var selectedRelationshipStatus: filterState
    let buttonRelationshipStatus: filterState
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
        case .showAll:
            return "person.crop.rectangle.stack"
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
        case .showAll:
            return "      "
        case .crush:
            return "crush"
        case .relationship:
            return "dating"
        case .bestie:
            return "bestie"
        case .friend:
            return "friend"
        }
    }
    
    private func returnIconSize() -> Int {
        switch buttonRelationshipStatus {
        case .showAll:
            return 24
        case .crush:
            return 26
        case .relationship:
            return 26
        case .bestie:
            return 21
        case .friend:
            return 20
        }
    }
    
    
    var body: some View {
        
        let matching: Bool = selectedRelationshipStatus == buttonRelationshipStatus
        
        Button {
            if matching {
                withAnimation(.snappy){ selectedRelationshipStatus = .showAll }
            }  else {
                withAnimation(.snappy){ selectedRelationshipStatus = buttonRelationshipStatus }
            }
        } label: {
            ZStack {
                if matching {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 78, height:61)
                        .foregroundStyle(accentColor)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 78, height:61)
                        .foregroundStyle(.thinMaterial)
                }
                Image(systemName: returnIconString())
                    .font(.system(size: CGFloat(returnIconSize())))
                    .foregroundStyle(returnColor(element: 1))
            }
        }
        .frame(width: 78, height:61)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .buttonStyle(PlainButtonStyle())
        .clipped()
        .minimumScaleFactor(0.1)
    }
    
}

#Preview {
    @Previewable @State var searchFilter: filterState = .showAll
    HStack {
        Filterbutton(selectedRelationshipStatus: $searchFilter, buttonRelationshipStatus: .friend, accentColor: .green)
        Filterbutton(selectedRelationshipStatus: $searchFilter, buttonRelationshipStatus: .bestie, accentColor: .blue)
        Filterbutton(selectedRelationshipStatus: $searchFilter, buttonRelationshipStatus: .crush, accentColor: .orange)
        Filterbutton(selectedRelationshipStatus: $searchFilter, buttonRelationshipStatus: .relationship, accentColor: .red)
    }
}
